using System;
using System.IO;
using Org.BouncyCastle.Pkcs;
using iText.Kernel.Pdf;
using iText.Signatures;
using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.X509;
using System.Collections.Generic;
using iText.Kernel.Geom;
using Net.Pkcs11Interop.Common;
using Net.Pkcs11Interop.HighLevelAPI;
using Org.BouncyCastle.Security;
using iText.Bouncycastle.Crypto;
using iText.Bouncycastleconnector;
using iText.Bouncycastle.X509;
using iText.Commons.Bouncycastle.Cert;
using iText.Commons.Bouncycastle.Crypto;
using iText.Kernel.Pdf.Canvas.Parser;
using iText.Kernel.Pdf.Canvas.Parser.Listener;
using iText.Kernel.Pdf.Canvas.Parser.Data;

namespace InvoicePdfSigner
{
    // A wrapper implementing IExternalSignature using Pkcs11Interop
    public class Pkcs11Signature : IExternalSignature
    {
        private readonly Pkcs11InteropFactories _factories;
        private readonly ISession _session;
        private readonly IObjectHandle _privateKey;
        private readonly string _hashAlgorithm;

        public Pkcs11Signature(Pkcs11InteropFactories factories, ISession session, IObjectHandle privateKey, string hashAlgorithm)
        {
            _factories = factories;
            _session = session;
            _privateKey = privateKey;
            _hashAlgorithm = hashAlgorithm;
        }

        public string GetHashAlgorithm()
        {
            return _hashAlgorithm;
        }

        public string GetDigestAlgorithmName()
        {
            return _hashAlgorithm;
        }

        public string GetEncryptionAlgorithm()
        {
            return "RSA";
        }

        public string GetSignatureAlgorithmName()
        {
            return "RSA";
        }

        public ISignatureMechanismParams GetSignatureMechanismParameters()
        {
            return null;
        }

        public byte[] Sign(byte[] message)
        {
            // For RSA SHA-256, we use Mechanism CKM_RSA_PKCS
            var mechanism = _factories.MechanismFactory.Create(CKM.CKM_RSA_PKCS);
            
            // Note: iText passes the hash of the document, not the document itself!
            // Wait, iText's Sign method usually receives the raw hash (if using detached).
            // Actually, iText requires us to sign the hash. CKM_RSA_PKCS expects the DigestInfo ASN.1 wrapper.
            // BouncyCastle can create the DigestInfo wrapper:
            var digestInfo = DigestUtilities.CalculateDigest("SHA-256", message);
            // Wait, no, iText `message` is already the hash? Actually iText `message` is the raw bytes to be hashed if we don't pre-hash, OR it's the hash. 
            // In iText7 IExternalSignature, `message` is the raw data, and we must return the signed hash.
            
            byte[] hash = DigestUtilities.CalculateDigest("SHA-256", message);
            
            // ASN.1 wrapper for SHA-256
            byte[] digestInfoBytes = new byte[] {
                0x30, 0x31, 0x30, 0x0d, 0x06, 0x09, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01, 0x05, 0x00, 0x04, 0x20
            };
            
            byte[] dataToSign = new byte[digestInfoBytes.Length + hash.Length];
            Buffer.BlockCopy(digestInfoBytes, 0, dataToSign, 0, digestInfoBytes.Length);
            Buffer.BlockCopy(hash, 0, dataToSign, digestInfoBytes.Length, hash.Length);

            return _session.Sign(mechanism, _privateKey, dataToSign);
        }
    }

    class Program
    {
        static int Main(string[] args)
        {
            if (args.Length < 5)
            {
                Console.WriteLine("Usage: pdf_signer file <input_pdf> <output_pdf> <pfx_path> <password>");
                Console.WriteLine("       pdf_signer token <input_pdf> <output_pdf> <dll_path> <pin>");
                return 2;
            }

            string mode = args[0];
            string inputPdf = args[1];
            string outputPdf = args[2];
            string credentialPath = args[3]; // pfx_path or dll_path
            string secret = args[4];         // password or pin

            if (!File.Exists(inputPdf)) return 2;

            if (mode == "file")
            {
                return SignFile(inputPdf, outputPdf, credentialPath, secret);
            }
            else if (mode == "token")
            {
                return SignToken(inputPdf, outputPdf, credentialPath, secret);
            }

            return 2;
        }

        static int SignFile(string inputPdf, string outputPdf, string pfxPath, string password)
        {
            try
            {
                if (!File.Exists(pfxPath)) return 2;

                Pkcs12Store pkcs12Store = new Pkcs12StoreBuilder().Build();
                using (var fs = new FileStream(pfxPath, FileMode.Open, FileAccess.Read))
                {
                    pkcs12Store.Load(fs, password.ToCharArray());
                }

                string? alias = null;
                foreach (string al in pkcs12Store.Aliases)
                {
                    if (pkcs12Store.IsKeyEntry(al) && pkcs12Store.GetKey(al).Key.IsPrivate)
                    {
                        alias = al;
                        break;
                    }
                }

                if (alias == null) return 2;

                AsymmetricKeyEntry pk = pkcs12Store.GetKey(alias);
                X509CertificateEntry[] ce = pkcs12Store.GetCertificateChain(alias);
                IX509Certificate[] chain = new IX509Certificate[ce.Length];
                for (int k = 0; k < ce.Length; ++k) chain[k] = new X509CertificateBC(ce[k].Certificate);

                string commonName = "Authorized Signatory";
                try {
                    foreach (var part in ce[0].Certificate.SubjectDN.ToString().Split(',')) {
                        if (part.Trim().StartsWith("CN=")) { commonName = part.Trim().Substring(3); break; }
                    }
                } catch { }
                for (int i = 0; i < inputs.Length; i++) {
                    if (i < outputs.Length) {
                        ApplySignature(inputs[i], outputs[i], chain, new PrivateKeySignature(new PrivateKeyBC(pk.Key), DigestAlgorithms.SHA256), commonName);
                    }
                }
                return 0;
            }
            catch (IOException ex)
            {
                if (ex.Message.Contains("PKCS12") || ex.Message.Contains("password")) return 1;
                return 3;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                return 3;
            }
        }

        static int StampLabel(string inputPdf, string outputPdf, string labelText)
        {
            try
            {
                using (PdfReader reader = new PdfReader(inputPdf))
                using (FileStream os = new FileStream(outputPdf, FileMode.Create))
                using (PdfDocument pdfDoc = new PdfDocument(reader, new PdfWriter(os), new StampingProperties().UseAppendMode()))
                {
                    int n = pdfDoc.GetNumberOfPages();
                    var font = iText.Kernel.Font.PdfFontFactory.CreateFont(iText.IO.Font.Constants.StandardFonts.HELVETICA_OBLIQUE);
                    for (int i = 1; i <= n; i++)
                    {
                        var page = pdfDoc.GetPage(i);
                        var canvas = new iText.Kernel.Pdf.Canvas.PdfCanvas(page);
                        // A4 width is 595. Right margin is 32. We can right align the text.
                        // Wait, easier to use Canvas layout object.
                        var layoutCanvas = new iText.Layout.Canvas(canvas, page.GetPageSize());
                        var p = new iText.Layout.Element.Paragraph(labelText)
                            .SetFont(font)
                            .SetFontSize(10)
                            .SetTextAlignment(iText.Layout.Properties.TextAlignment.RIGHT);
                        
                        // ShowTextAligned is easier
                        layoutCanvas.ShowTextAligned(p, 595 - 32, 842 - 32 - 10, iText.Layout.Properties.TextAlignment.RIGHT);
                        layoutCanvas.Close();
                    }
                }
                return 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                return 1;
            }
        }

        static int SignToken(string inputPdf, string outputPdf, string dllPath, string pin)
        {
            // If inputPdf contains multiple files separated by '|', process all
            string[] inputs = inputPdf.Split('|');
            string[] outputs = outputPdf.Split('|');
            
            try
            {
                if (!File.Exists(dllPath))
                {
                    Console.WriteLine("DLL not found at: " + dllPath + ". Please check if the path is correct in Settings, and ensure you have installed the correct 64-bit/32-bit drivers for your token.");
                    return 4; // DLL not found
                }

                Pkcs11InteropFactories factories = new Pkcs11InteropFactories();
                using (IPkcs11Library pkcs11Library = factories.Pkcs11LibraryFactory.LoadPkcs11Library(factories, dllPath, AppType.MultiThreaded))
                {
                    ISlot? tokenSlot = null;
                    foreach (ISlot slot in pkcs11Library.GetSlotList(SlotsType.WithTokenPresent))
                    {
                        tokenSlot = slot;
                        break;
                    }

                    if (tokenSlot == null)
                    {
                        Console.WriteLine("No USB token found. Please ensure the token is plugged in and recognized by the system.");
                        return 6; // Hardware Error (No token)
                    }

                    using (ISession session = tokenSlot.OpenSession(SessionType.ReadWrite))
                    {
                        try
                        {
                            session.Login(CKU.CKU_USER, pin);
                        }
                        catch (Pkcs11Exception ex) when (ex.RV == CKR.CKR_PIN_INCORRECT)
                        {
                            Console.WriteLine("Incorrect PIN entered for the USB token.");
                            return 5; // Incorrect PIN
                        }

                        // Find Private Key
                        var keyAttributes = new List<IObjectAttribute>
                        {
                            factories.ObjectAttributeFactory.Create(CKA.CKA_CLASS, CKO.CKO_PRIVATE_KEY)
                        };
                        var keys = session.FindAllObjects(keyAttributes);
                        if (keys.Count == 0) return 6;
                        IObjectHandle privateKey = keys[0];

                        // Find Certificate
                        var certAttributes = new List<IObjectAttribute>
                        {
                            factories.ObjectAttributeFactory.Create(CKA.CKA_CLASS, CKO.CKO_CERTIFICATE)
                        };
                        var certs = session.FindAllObjects(certAttributes);
                        if (certs.Count == 0) return 6;
                        
                        // Extract X509
                        var valueAttr = session.GetAttributeValue(certs[0], new List<CKA> { CKA.CKA_VALUE });
                        byte[] certBytes = valueAttr[0].GetValueAsByteArray();
                        var parser = new X509CertificateParser();
                        X509Certificate certificate = parser.ReadCertificate(certBytes);

                        IX509Certificate[] chain = new IX509Certificate[] { new X509CertificateBC(certificate) };
                        IExternalSignature signature = new Pkcs11Signature(factories, session, privateKey, DigestAlgorithms.SHA256);

                        string commonName = "Authorized Signatory";
                        try {
                            foreach (var part in certificate.SubjectDN.ToString().Split(',')) {
                                if (part.Trim().StartsWith("CN=")) { commonName = part.Trim().Substring(3); break; }
                            }
                        } catch { }
                        for (int i = 0; i < inputs.Length; i++) {
                            if (i < outputs.Length) {
                                ApplySignature(inputs[i], outputs[i], chain, signature, commonName);
                            }
                        }
                        
                        session.Logout();
                    }
                }

                return 0; // Success
            }
            catch (Exception ex)
            {
                Console.WriteLine("Hardware/Token Error: " + ex.Message + " | Details: " + ex.ToString());
                return 6; // Generic hardware/PKCS#11 error
            }
        }

        class SignLocator : IEventListener
        {
            public float TargetX = 400;
            public float TargetY = 50;
            
            private string _accumulatedText = "";
            private float _currentX = 0;
            private float _currentY = 0;
            private float _lastY = 0;

            public void EventOccurred(IEventData data, EventType type)
            {
                if (type == EventType.RENDER_TEXT)
                {
                    var renderInfo = (TextRenderInfo)data;
                    string text = renderInfo.GetText();
                    if (text != null)
                    {
                        var rect = renderInfo.GetBaseline().GetBoundingRectangle();
                        if (Math.Abs(rect.GetY() - _lastY) > 5) 
                        {
                            _accumulatedText = "";
                            _currentX = rect.GetX();
                            _currentY = rect.GetY();
                        }
                        
                        _accumulatedText += text.Replace(" ", "").ToUpper();
                        _lastY = rect.GetY();

                        if (_accumulatedText.Contains("SIG_LOC"))
                        {
                            TargetX = _currentX;
                            TargetY = _currentY - 70;
                        }
                    }
                }
            }

            public ICollection<EventType> GetSupportedEvents()
            {
                return new List<EventType> { EventType.RENDER_TEXT };
            }
        }

        static void ApplySignature(string inputPdf, string outputPdf, IX509Certificate[] chain, IExternalSignature signature, string commonName)
        {
            float targetX = 400;
            float targetY = 50;
            int lastPage = 1;
            
            using (PdfReader locatorReader = new PdfReader(inputPdf))
            using (PdfDocument locatorDoc = new PdfDocument(locatorReader))
            {
                lastPage = locatorDoc.GetNumberOfPages();
                var locator = new SignLocator();
                PdfCanvasProcessor processor = new PdfCanvasProcessor(locator);
                processor.ProcessPageContent(locatorDoc.GetPage(lastPage));
                targetX = locator.TargetX;
                targetY = locator.TargetY;
            }

            string tempPdf = inputPdf + ".tmp";
            using (PdfReader reader = new PdfReader(inputPdf))
            using (PdfWriter writer = new PdfWriter(tempPdf))
            using (PdfDocument pdfDoc = new PdfDocument(reader, writer, new StampingProperties().UseAppendMode()))
            {
                var page = pdfDoc.GetPage(lastPage);
                var canvas = new iText.Kernel.Pdf.Canvas.PdfCanvas(page);
                var font = iText.Kernel.Font.PdfFontFactory.CreateFont(iText.IO.Font.Constants.StandardFonts.HELVETICA);
                canvas.BeginText();
                canvas.SetFontAndSize(font, 8);
                canvas.SetFillColor(iText.Kernel.Colors.ColorConstants.BLACK);
                canvas.MoveText(targetX, targetY + 30);
                canvas.ShowText("Digitally signed by " + commonName);
                canvas.MoveText(0, -15);
                canvas.ShowText("Date: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " +05'30'");
                canvas.EndText();
            }

            using (PdfReader reader = new PdfReader(tempPdf))
            using (FileStream os = new FileStream(outputPdf, FileMode.Create))
            {
                PdfSigner signer = new PdfSigner(reader, os, new StampingProperties().UseAppendMode());
                
                Rectangle rect = new Rectangle(targetX, targetY, 150, 50);

                PdfSignatureAppearance appearance = signer.GetSignatureAppearance();
                appearance
                    .SetReason("Invoice Signature")
                    .SetLocation("India")
                    .SetPageRect(rect)
                    .SetPageNumber(lastPage)
                    .SetLayer2Text($"Digitally signed by {commonName}\nDate: {DateTime.Now:yyyy-MM-dd HH:mm:ss} +05'30'");
                
                signer.SetFieldName("AuthorizedSignatory");
                signer.SignDetached(signature, chain, null, null, null, 0, PdfSigner.CryptoStandard.CMS);
            }
            try { System.IO.File.Delete(tempPdf); } catch { }
        }
    }
}
