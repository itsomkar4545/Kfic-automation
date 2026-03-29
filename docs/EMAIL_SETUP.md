# Jenkins Email Configuration Guide

## 📧 Setup Email Notifications for KFIC Framework

### Step 1: Configure SMTP in Jenkins
**Manage Jenkins > Configure System > Email Extension Plugin**

#### Gmail Configuration:
```
SMTP Server: smtp.gmail.com
SMTP Port: 587
Use SMTP Authentication: ✅ Checked
Username: your-email@gmail.com
Password: your-app-password (not regular password)
Use SSL: ✅ Checked
```

#### Outlook/Hotmail Configuration:
```
SMTP Server: smtp-mail.outlook.com
SMTP Port: 587
Use SMTP Authentication: ✅ Checked
Username: your-email@outlook.com
Password: your-password
Use SSL: ✅ Checked
```

#### Corporate Email Configuration:
```
SMTP Server: mail.kfic.com (ask IT team)
SMTP Port: 587 or 25
Use SMTP Authentication: ✅ Checked
Username: your-username
Password: your-password
```

### Step 2: Update Email Address in Jenkinsfile
Replace `omkar.patil@kfic.com` with your email in these lines:
```groovy
to: "your-email@kfic.com"  // Line 85, 105, 135
```

### Step 3: Test Email Configuration
1. **Manage Jenkins > Configure System**
2. **Email Extension Plugin section**
3. **Click "Test configuration"**
4. **Enter your email and click "Test e-mail"**

### Step 4: Gmail App Password Setup (if using Gmail)
1. **Google Account Settings > Security**
2. **Enable 2-Step Verification**
3. **Generate App Password**:
   - Select app: Mail
   - Select device: Other (Jenkins)
   - Copy the 16-character password
4. **Use this app password in Jenkins (not your regular password)**

## 📨 Email Features You'll Get

### 🎯 **Always Sent (After Every Build):**
- **HTML formatted report** with test summary
- **Pass/Fail statistics** with percentages
- **Performance metrics** (parallel execution info)
- **Quick links** to detailed reports
- **Attachments**: report.html, log.html, output.xml

### ✅ **Success Email:**
- **Green colored** success notification
- **Celebration message** 🎉
- **Summary statistics**
- **Links to detailed results**

### ❌ **Failure Email:**
- **Red colored** urgent notification
- **Detailed failure information**
- **Investigation links** (console, logs, artifacts)
- **Next steps** for troubleshooting
- **Attachments** with error details

## 📋 Sample Email Content

### Success Email:
```
Subject: ✅ KFIC Tests PASSED - Build #123

🎉 Great news! All KFIC automation tests have passed successfully.

📊 KFIC Test Execution Summary
================================
✅ Passed: 8
❌ Failed: 0
📈 Total: 8
🎯 Pass Rate: 100%
⏱️ Duration: 3 min 45 sec
🌐 Environment: qc
🔧 Browser: chrome

View detailed results: http://jenkins:8080/job/KFIC-Automation/123/robot/
```

### Failure Email:
```
Subject: ❌ KFIC Tests FAILED - Build #124 - URGENT

🚨 KFIC Test Execution Failed

❌ Failure Summary
✅ Passed: 6
❌ Failed: 2
📈 Total: 8
🎯 Pass Rate: 75%

🔍 Investigation Links:
- Failed Test Details
- Console Output  
- All Artifacts

🛠️ Next Steps:
1. Check the detailed log for error messages
2. Verify environment connectivity
3. Review failed test cases
4. Fix issues and re-run tests
```

## 🔧 Troubleshooting Email Issues

### Common Problems:

| Issue | Solution |
|-------|----------|
| No emails received | Check SMTP configuration and test |
| Gmail authentication failed | Use App Password, not regular password |
| Corporate email blocked | Contact IT team for SMTP settings |
| Attachments not received | Check Jenkins file permissions |

### Debug Steps:
1. **Check Jenkins logs**: `Manage Jenkins > System Log`
2. **Test SMTP**: Use "Test configuration" button
3. **Verify email address**: Check for typos in Jenkinsfile
4. **Check spam folder**: Automated emails might go to spam

## 📱 Additional Notifications (Optional)

### Slack Integration:
```groovy
slackSend channel: '#automation',
          message: "KFIC Tests: ${currentBuild.result} - ${BUILD_URL}"
```

### Teams Integration:
```groovy
office365ConnectorSend webhookUrl: 'YOUR_TEAMS_WEBHOOK',
                      message: "KFIC Test Results: ${currentBuild.result}"
```

## 🎯 Email Best Practices

### 1. **Multiple Recipients:**
```groovy
to: "omkar.patil@kfic.com, team-lead@kfic.com, qa-team@kfic.com"
```

### 2. **Different Emails for Different Results:**
- **Success**: Only to individual
- **Failure**: To entire team
- **Critical**: To management

### 3. **Scheduled Reports:**
```groovy
// Daily summary email
if (env.BUILD_CAUSE == 'TIMERTRIGGER') {
    // Send daily summary
}
```

---

**After setup, you'll receive detailed email reports for every test execution! 📧✨**