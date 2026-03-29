pipeline {
    agent any
    
    environment {
        PYTHON_PATH = 'C:\\Python313'  // Adjust path as per your system
        BROWSER = 'chrome'
        ENVIRONMENT = 'qc'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Setup') {
            steps {
                echo 'Installing dependencies...'
                bat '''
                    pip install -r requirements.txt
                '''
            }
        }
        
        stage('Run Tests') {
            parallel {
                stage('Smoke Tests') {
                    steps {
                        echo 'Running smoke tests...'
                        bat '''
                            robot --variable BROWSER:%BROWSER% ^
                                  --variable ENVIRONMENT:%ENVIRONMENT% ^
                                  --include smoke ^
                                  --outputdir results/smoke ^
                                  tests/
                        '''
                    }
                }
                
                stage('Receipt Tests') {
                    steps {
                        echo 'Running receipt tests...'
                        bat '''
                            robot --variable BROWSER:%BROWSER% ^
                                  --variable ENVIRONMENT:%ENVIRONMENT% ^
                                  --include receipt ^
                                  --outputdir results/receipt ^
                                  tests/
                        '''
                    }
                }
            }
        }
        
        stage('Parallel Execution') {
            steps {
                echo 'Running all tests in parallel...'
                bat '''
                    pabot --processes 4 ^
                          --variable BROWSER:%BROWSER% ^
                          --variable ENVIRONMENT:%ENVIRONMENT% ^
                          --outputdir results/parallel ^
                          tests/
                '''
            }
        }
    }
    
    post {
        always {
            echo 'Publishing test results...'
            
            // Archive test results
            archiveArtifacts artifacts: 'results/**/*', fingerprint: true
            
            // Publish Robot Framework results
            robot outputPath: 'results', 
                  reportFileName: 'report.html', 
                  logFileName: 'log.html'
            
            // Generate test summary
            script {
                def testResults = readFile('results/output.xml')
                def passed = (testResults =~ /pass="(\d+)"/)[0][1]
                def failed = (testResults =~ /fail="(\d+)"/)[0][1]
                def total = Integer.parseInt(passed) + Integer.parseInt(failed)
                def passRate = (Integer.parseInt(passed) * 100 / total).round(2)
                
                env.TEST_SUMMARY = """
                📊 KFIC Test Execution Summary
                ================================
                ✅ Passed: ${passed}
                ❌ Failed: ${failed}
                📈 Total: ${total}
                🎯 Pass Rate: ${passRate}%
                ⏱️ Duration: ${currentBuild.durationString}
                🌐 Environment: ${ENVIRONMENT}
                🔧 Browser: ${BROWSER}
                """
            }
            
            // Send detailed email with attachments
            emailext (
                subject: "🚀 KFIC Test Results - Build #${BUILD_NUMBER} - ${currentBuild.result}",
                mimeType: 'text/html',
                body: """
                    <html>
                    <body style="font-family: Arial, sans-serif;">
                        <h2 style="color: ${currentBuild.result == 'SUCCESS' ? 'green' : 'red'};">KFIC Automation Test Results</h2>
                        
                        <div style="background-color: #f5f5f5; padding: 15px; border-radius: 5px;">
                            <h3>📊 Test Summary</h3>
                            <pre>${env.TEST_SUMMARY}</pre>
                        </div>
                        
                        <div style="margin-top: 20px;">
                            <h3>🔗 Quick Links</h3>
                            <ul>
                                <li><a href="${BUILD_URL}">📋 Build Details</a></li>
                                <li><a href="${BUILD_URL}robot/">🤖 Robot Framework Report</a></li>
                                <li><a href="${BUILD_URL}artifact/results/report.html">📊 Test Report</a></li>
                                <li><a href="${BUILD_URL}artifact/results/log.html">📝 Detailed Log</a></li>
                            </ul>
                        </div>
                        
                        <div style="margin-top: 20px; padding: 10px; background-color: #e8f4fd; border-radius: 5px;">
                            <h3>📈 Performance Metrics</h3>
                            <p><strong>Execution Mode:</strong> Parallel (4 processes)</p>
                            <p><strong>Speed Improvement:</strong> ~4x faster than sequential</p>
                            <p><strong>Framework:</strong> KFIC Advanced Automation</p>
                        </div>
                        
                        <div style="margin-top: 20px; font-size: 12px; color: #666;">
                            <p>This is an automated message from Jenkins CI/CD Pipeline.</p>
                            <p>Build triggered at: ${new Date()}</p>
                        </div>
                    </body>
                    </html>
                """,
                to: "omkar.patil@kiya.ai",  // Replace with your email
                attachmentsPattern: "results/report.html, results/log.html, results/output.xml",
                attachLog: true
            )
        }
        
        success {
            echo 'All tests passed! ✅'
            
            // Send success notification
            emailext (
                subject: "✅ KFIC Tests PASSED - Build #${BUILD_NUMBER}",
                body: """
                    🎉 Great news! All KFIC automation tests have passed successfully.
                    
                    ${env.TEST_SUMMARY}
                    
                    View detailed results: ${BUILD_URL}robot/
                """,
                to: "omkar.patil@kiya.ai"
            )
        }
        
        failure {
            echo 'Some tests failed! ❌'
            
            // Send failure notification with details
            emailext (
                subject: "❌ KFIC Tests FAILED - Build #${BUILD_NUMBER} - URGENT",
                mimeType: 'text/html',
                body: """
                    <html>
                    <body style="font-family: Arial, sans-serif;">
                        <h2 style="color: red;">🚨 KFIC Test Execution Failed</h2>
                        
                        <div style="background-color: #ffe6e6; padding: 15px; border-radius: 5px; border-left: 5px solid red;">
                            <h3>❌ Failure Summary</h3>
                            <pre>${env.TEST_SUMMARY}</pre>
                        </div>
                        
                        <div style="margin-top: 20px;">
                            <h3>🔍 Investigation Links</h3>
                            <ul>
                                <li><a href="${BUILD_URL}robot/">🤖 Failed Test Details</a></li>
                                <li><a href="${BUILD_URL}console">📋 Console Output</a></li>
                                <li><a href="${BUILD_URL}artifact/results/">📁 All Artifacts</a></li>
                            </ul>
                        </div>
                        
                        <div style="margin-top: 20px; padding: 10px; background-color: #fff3cd; border-radius: 5px;">
                            <h3>🛠️ Next Steps</h3>
                            <ol>
                                <li>Check the detailed log for error messages</li>
                                <li>Verify environment connectivity</li>
                                <li>Review failed test cases</li>
                                <li>Fix issues and re-run tests</li>
                            </ol>
                        </div>
                    </body>
                    </html>
                """,
                to: "omkar.patil@kiya.ai",
                attachmentsPattern: "results/report.html, results/log.html"
            )
        }
    }
}