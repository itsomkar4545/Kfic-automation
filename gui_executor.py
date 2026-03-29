import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import subprocess
import os
import threading
import glob
import json
from datetime import datetime
import webbrowser

class AdvancedKFICExecutor:
    def __init__(self, root):
        self.root = root
        self.root.title("KFIC Advanced Test Executor")
        self.root.geometry("800x600")
        
        self.test_running = False
        self.test_queue = []
        self.setup_ui()
        self.load_config()
        self.refresh_tests()
        
    def setup_ui(self):
        # Create notebook for tabs
        notebook = ttk.Notebook(self.root)
        notebook.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Test Execution Tab
        self.exec_frame = ttk.Frame(notebook)
        notebook.add(self.exec_frame, text="Test Execution")
        self.setup_execution_tab()
        
        # Batch Execution Tab
        self.batch_frame = ttk.Frame(notebook)
        notebook.add(self.batch_frame, text="Batch Execution")
        self.setup_batch_tab()
        
        # Reports Tab
        self.reports_frame = ttk.Frame(notebook)
        notebook.add(self.reports_frame, text="Reports & Analytics")
        self.setup_reports_tab()
        
    def setup_execution_tab(self):
        # Test Selection
        ttk.Label(self.exec_frame, text="Select Test:", font=("Arial", 10, "bold")).grid(row=0, column=0, sticky=tk.W, pady=5)
        self.test_var = tk.StringVar()
        self.test_combo = ttk.Combobox(self.exec_frame, textvariable=self.test_var, width=60)
        self.test_combo.grid(row=0, column=1, columnspan=2, sticky=(tk.W, tk.E), pady=5)
        
        # Configuration Frame
        config_frame = ttk.LabelFrame(self.exec_frame, text="Configuration")
        config_frame.grid(row=1, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=10, padx=5)
        
        # Browser
        ttk.Label(config_frame, text="Browser:").grid(row=0, column=0, sticky=tk.W, padx=5, pady=2)
        self.browser_var = tk.StringVar(value="chrome")
        ttk.Combobox(config_frame, textvariable=self.browser_var, values=('chrome', 'firefox', 'edge'), width=15).grid(row=0, column=1, padx=5, pady=2)
        
        # Environment
        ttk.Label(config_frame, text="Environment:").grid(row=0, column=2, sticky=tk.W, padx=5, pady=2)
        self.env_var = tk.StringVar(value="qc")
        ttk.Combobox(config_frame, textvariable=self.env_var, values=('qc', 'dev', 'uat', 'prod'), width=15).grid(row=0, column=3, padx=5, pady=2)
        
        # Options
        self.headless_var = tk.BooleanVar()
        ttk.Checkbutton(config_frame, text="Headless", variable=self.headless_var).grid(row=1, column=0, sticky=tk.W, padx=5, pady=2)
        
        self.parallel_var = tk.BooleanVar()
        ttk.Checkbutton(config_frame, text="Parallel", variable=self.parallel_var).grid(row=1, column=1, sticky=tk.W, padx=5, pady=2)
        
        self.screenshot_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(config_frame, text="Screenshots", variable=self.screenshot_var).grid(row=1, column=2, sticky=tk.W, padx=5, pady=2)
        
        # Buttons
        btn_frame = ttk.Frame(self.exec_frame)
        btn_frame.grid(row=2, column=0, columnspan=3, pady=10)
        
        self.run_btn = ttk.Button(btn_frame, text="🚀 Run Test", command=self.run_single_test)
        self.run_btn.pack(side=tk.LEFT, padx=5)
        
        ttk.Button(btn_frame, text="🔄 Refresh", command=self.refresh_tests).pack(side=tk.LEFT, padx=5)
        ttk.Button(btn_frame, text="📊 View Report", command=self.view_latest_report).pack(side=tk.LEFT, padx=5)
        ttk.Button(btn_frame, text="⏹️ Stop", command=self.stop_execution).pack(side=tk.LEFT, padx=5)
        
        # Progress
        self.progress = ttk.Progressbar(self.exec_frame, mode='indeterminate')
        self.progress.grid(row=3, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=5)
        
        # Status
        self.status_var = tk.StringVar(value="Ready")
        ttk.Label(self.exec_frame, textvariable=self.status_var, foreground="blue").grid(row=4, column=0, columnspan=3, pady=2)
        
        # Output
        self.output_text = tk.Text(self.exec_frame, height=15, width=80)
        scrollbar = ttk.Scrollbar(self.exec_frame, orient=tk.VERTICAL, command=self.output_text.yview)
        self.output_text.configure(yscrollcommand=scrollbar.set)
        self.output_text.grid(row=5, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S), pady=5)
        scrollbar.grid(row=5, column=3, sticky=(tk.N, tk.S), pady=5)
        
        # Configure grid weights
        self.exec_frame.columnconfigure(1, weight=1)
        self.exec_frame.rowconfigure(5, weight=1)
    
    def setup_batch_tab(self):
        # Test Queue
        ttk.Label(self.batch_frame, text="Test Queue:", font=("Arial", 10, "bold")).grid(row=0, column=0, sticky=tk.W, pady=5)
        
        # Queue listbox
        self.queue_listbox = tk.Listbox(self.batch_frame, height=8, width=70)
        self.queue_listbox.grid(row=1, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=5)
        
        # Queue buttons
        queue_btn_frame = ttk.Frame(self.batch_frame)
        queue_btn_frame.grid(row=2, column=0, columnspan=3, pady=5)
        
        ttk.Button(queue_btn_frame, text="➕ Add Test", command=self.add_to_queue).pack(side=tk.LEFT, padx=5)
        ttk.Button(queue_btn_frame, text="➖ Remove", command=self.remove_from_queue).pack(side=tk.LEFT, padx=5)
        ttk.Button(queue_btn_frame, text="🗑️ Clear All", command=self.clear_queue).pack(side=tk.LEFT, padx=5)
        ttk.Button(queue_btn_frame, text="▶️ Run Queue", command=self.run_batch_tests).pack(side=tk.LEFT, padx=5)
        
        # Batch options
        batch_options = ttk.LabelFrame(self.batch_frame, text="Batch Options")
        batch_options.grid(row=3, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=10)
        
        self.continue_on_fail = tk.BooleanVar(value=True)
        ttk.Checkbutton(batch_options, text="Continue on Failure", variable=self.continue_on_fail).grid(row=0, column=0, sticky=tk.W, padx=5)
        
        self.email_report = tk.BooleanVar()
        ttk.Checkbutton(batch_options, text="Email Report", variable=self.email_report).grid(row=0, column=1, sticky=tk.W, padx=5)
        
        # Batch progress
        self.batch_progress = ttk.Progressbar(self.batch_frame, mode='determinate')
        self.batch_progress.grid(row=4, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=5)
        
        self.batch_status = tk.StringVar(value="Queue Empty")
        ttk.Label(self.batch_frame, textvariable=self.batch_status).grid(row=5, column=0, columnspan=3, pady=2)
    
    def setup_reports_tab(self):
        # Recent Reports
        ttk.Label(self.reports_frame, text="Recent Test Reports:", font=("Arial", 10, "bold")).grid(row=0, column=0, sticky=tk.W, pady=5)
        
        # Reports tree
        self.reports_tree = ttk.Treeview(self.reports_frame, columns=('Date', 'Test', 'Status', 'Duration'), show='headings', height=10)
        self.reports_tree.heading('Date', text='Date/Time')
        self.reports_tree.heading('Test', text='Test Name')
        self.reports_tree.heading('Status', text='Status')
        self.reports_tree.heading('Duration', text='Duration')
        self.reports_tree.grid(row=1, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S), pady=5)
        
        # Report buttons
        report_btn_frame = ttk.Frame(self.reports_frame)
        report_btn_frame.grid(row=2, column=0, columnspan=3, pady=5)
        
        ttk.Button(report_btn_frame, text="📊 Open Report", command=self.open_selected_report).pack(side=tk.LEFT, padx=5)
        ttk.Button(report_btn_frame, text="📁 Open Folder", command=self.open_results_folder).pack(side=tk.LEFT, padx=5)
        ttk.Button(report_btn_frame, text="🔄 Refresh", command=self.refresh_reports).pack(side=tk.LEFT, padx=5)
        ttk.Button(report_btn_frame, text="🗑️ Clean Old", command=self.clean_old_reports).pack(side=tk.LEFT, padx=5)
        
        # Configure grid weights
        self.reports_frame.columnconfigure(1, weight=1)
        self.reports_frame.rowconfigure(1, weight=1)
    
    def refresh_tests(self):
        robot_files = []
        for pattern in ['tests/*.robot', 'tests/*/*.robot']:
            robot_files.extend(glob.glob(pattern))
        
        robot_files = sorted([f.replace('\\', '/') for f in robot_files])
        robot_files.append('tests/ - All Tests')
        
        self.test_combo['values'] = robot_files
        if robot_files:
            self.test_combo.current(0)
        
        self.log_output(f"📁 Found {len(robot_files)-1} test files")
    
    def run_single_test(self):
        if self.test_running:
            messagebox.showwarning("Warning", "Test already running!")
            return
        
        test_path = self.test_var.get()
        if not test_path:
            messagebox.showerror("Error", "Please select a test")
            return
        
        self.execute_test(test_path)
    
    def execute_test(self, test_path):
        self.test_running = True
        self.run_btn.config(state='disabled')
        self.progress.start()
        self.status_var.set("Running...")
        self.output_text.delete(1.0, tk.END)
        
        thread = threading.Thread(target=self._run_test, args=(test_path,))
        thread.daemon = True
        thread.start()
    
    def _run_test(self, test_path):
        try:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_dir = f"results/run_{timestamp}"
            
            if test_path.endswith('All Tests'):
                test_path = 'tests/'
            else:
                test_path = test_path.split(' - ')[0] if ' - ' in test_path else test_path
            
            # Use pabot for parallel execution if enabled and running multiple tests
            if self.parallel_var.get() and (test_path.endswith('/') or 'tests/' in test_path or test_path.endswith('.robot')):
                cmd = [
                    "pabot", 
                    "--processes", "4",
                    "--testlevelsplit",
                    "--outputdir", output_dir
                ]
                self.log_output("🚀 Running tests in PARALLEL mode (4 processes) - Test Level Split")
            else:
                cmd = ["robot", "--outputdir", output_dir]
                self.log_output("🚀 Running tests in SEQUENTIAL mode")
            
            if self.screenshot_var.get():
                cmd.extend(["--variable", "SCREENSHOT_ON_FAILURE:True"])
            
            cmd.extend([
                f"--variable", f"BROWSER:{self.browser_var.get()}",
                f"--variable", f"ENVIRONMENT:{self.env_var.get()}",
                "--timestampoutputs",
                "--log", "log.html",
                "--report", "report.html",
                test_path
            ])
            
            self.log_output(f"📁 Test Path: {test_path}")
            self.log_output(f"📋 Command: {' '.join(cmd)}\n")
            
            process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
            
            for line in process.stdout:
                self.log_output(line.rstrip())
            
            process.wait()
            
            if process.returncode == 0:
                self.log_output("\n✅ Test completed successfully!")
                if self.parallel_var.get():
                    self.log_output("⚡ Parallel execution completed - Check speed improvement!")
                self.status_var.set("✅ Success")
            else:
                self.log_output(f"\n❌ Test failed (code: {process.returncode})")
                self.status_var.set("❌ Failed")
            
            self.save_test_result(test_path, process.returncode, timestamp)
            
        except Exception as e:
            self.log_output(f"\n💥 Error: {str(e)}")
            self.status_var.set("💥 Error")
        finally:
            self.test_running = False
            self.run_btn.config(state='normal')
            self.progress.stop()
    
    def log_output(self, message):
        self.output_text.insert(tk.END, f"{message}\n")
        self.output_text.see(tk.END)
        self.root.update()
    
    def add_to_queue(self):
        test = self.test_var.get()
        if test and test not in self.test_queue:
            self.test_queue.append(test)
            self.queue_listbox.insert(tk.END, test)
            self.batch_status.set(f"Queue: {len(self.test_queue)} tests")
    
    def remove_from_queue(self):
        selection = self.queue_listbox.curselection()
        if selection:
            index = selection[0]
            self.queue_listbox.delete(index)
            del self.test_queue[index]
            self.batch_status.set(f"Queue: {len(self.test_queue)} tests")
    
    def clear_queue(self):
        self.queue_listbox.delete(0, tk.END)
        self.test_queue.clear()
        self.batch_status.set("Queue Empty")
    
    def run_batch_tests(self):
        if not self.test_queue:
            messagebox.showwarning("Warning", "Queue is empty!")
            return
        
        if self.test_running:
            messagebox.showwarning("Warning", "Test already running!")
            return
        
        thread = threading.Thread(target=self._run_batch)
        thread.daemon = True
        thread.start()
    
    def _run_batch(self):
        total_tests = len(self.test_queue)
        self.batch_progress['maximum'] = total_tests
        
        for i, test in enumerate(self.test_queue):
            self.batch_status.set(f"Running {i+1}/{total_tests}: {test}")
            self.batch_progress['value'] = i
            
            # Run test (simplified for batch)
            self.execute_test(test)
            
            # Wait for completion
            while self.test_running:
                self.root.update()
                threading.Event().wait(0.1)
        
        self.batch_progress['value'] = total_tests
        self.batch_status.set(f"✅ Batch completed: {total_tests} tests")
    
    def view_latest_report(self):
        # Look for reports in multiple locations
        report_locations = [
            "results/*/report.html",
            "report.html",
            "results/report.html"
        ]
        
        report_files = []
        for pattern in report_locations:
            report_files.extend(glob.glob(pattern))
        
        if report_files:
            latest_report = max(report_files, key=os.path.getctime)
            self.log_output(f"📊 Opening report: {latest_report}")
            webbrowser.open(f"file://{os.path.abspath(latest_report)}")
        else:
            self.log_output("📊 No reports found. Check results folder.")
            messagebox.showinfo("Info", "No reports found. Run tests first.")
    
    def stop_execution(self):
        # Implementation for stopping tests
        self.status_var.set("⏹️ Stopped")
    
    def save_test_result(self, test_path, return_code, timestamp):
        # Save test results for reporting
        pass
    
    def refresh_reports(self):
        # Refresh reports tree
        pass
    
    def open_selected_report(self):
        # Open selected report
        pass
    
    def open_results_folder(self):
        if os.path.exists("results"):
            os.startfile("results")
    
    def clean_old_reports(self):
        # Clean old report files
        pass
    
    def load_config(self):
        # Load configuration from file
        pass

if __name__ == "__main__":
    root = tk.Tk()
    app = AdvancedKFICExecutor(root)
    root.mainloop()