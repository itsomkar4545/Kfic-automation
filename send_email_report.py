import smtplib
import os
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
import subprocess
from datetime import datetime

def send_test_report(email, password, recipient):
    # Run tests
    print("Running tests...")
    result = subprocess.run([
        "robot", 
        "--outputdir", "results",
        "tests/receipt_test.robot"
    ], capture_output=True, text=True)
    
    # Email setup
    msg = MIMEMultipart()
    msg['From'] = email
    msg['To'] = recipient
    msg['Subject'] = f"KFIC Test Results - {datetime.now().strftime('%Y-%m-%d %H:%M')}"
    
    # Email body
    if result.returncode == 0:
        body = "✅ All tests passed successfully!"
    else:
        body = "❌ Some tests failed. Check attached reports."
    
    msg.attach(MIMEText(body, 'plain'))
    
    # Attach report
    if os.path.exists("results/report.html"):
        with open("results/report.html", "rb") as attachment:
            part = MIMEBase('application', 'octet-stream')
            part.set_payload(attachment.read())
            encoders.encode_base64(part)
            part.add_header(
                'Content-Disposition',
                'attachment; filename= "test_report.html"'
            )
            msg.attach(part)
    
    # Send email
    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(email, password)
        server.sendmail(email, recipient, msg.as_string())
        server.quit()
        print("✅ Email sent successfully!")
    except Exception as e:
        print(f"❌ Email failed: {e}")

if __name__ == "__main__":
    # Update these
    sender_email = "your-email@gmail.com"
    sender_password = "your-app-password"  # Gmail app password
    recipient_email = "omkar.patil@kiya.ai"
    
    send_test_report(sender_email, sender_password, recipient_email)