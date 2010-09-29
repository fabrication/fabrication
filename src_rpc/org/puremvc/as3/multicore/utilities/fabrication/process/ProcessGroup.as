package org.puremvc.as3.multicore.utilities.fabrication.process {


    public class ProcessGroup extends Process {
		public static var NORM_THREADS:uint  = 1; /**< The default amount of threads for all ProcessGroup instances. */
		public static const MAX_THREADS:uint = uint.MAX_VALUE;  /**< The maximum amount of threads for a ProcessGroup instance. Use this value if you wish to disable threading. */
		protected var _threads:uint;
		protected var _processes:Array;
		protected var _autoStart:Boolean;



		/**
			Creates a new ProcessGroup.
		*/
		public function ProcessGroup( maximumParallelThreads:uint = 1 ) {
			super();
			threads = maximumParallelThreads;
			_processes = new Array();
		}

		override public function start():void {

            super.start();
            checkThreads();
        }

		override public function stop():void {
			_running = false;

			var l:uint = _processes.length;
			while (l--) {
				if (_processes[l].running) {
					_processes[l].stop();
					return;
				}
			}

			super.stop();
		}

		/**
			Instructs the ProcessGroup to {@link #start} automatically if it contains an incomplete {@link Process} or if an incomplete is {@link Process#addProcess added}.
		*/
		public function get autoStart():Boolean {
			return _autoStart;
		}

		public function set autoStart(autoStart:Boolean):void {
			_autoStart = autoStart;

			if (!completed && !running)
				start();
		}

		/**
			Adds a process to be threaded and run by the ProcessGroup.

			@param process: The process to be added and run by the group.
			@usageNote You can add a different instance of ProcessGroup to another ProcessGroup.
			@throws Error if you try add the same Process to itself.
		*/
		public function addProcess(process:IProcess):void {
			if (process == this)
				throw new Error('You cannot add the same Process to itself.');

			removeProcess(process);

			addProcessListeners(process);

			_hasCompleted = process.completed;
            _processes.push( process );
			if (autoStart && !completed) {
				if (running)
					checkThreads();
				else
					start();
			}
		}

		/**
			Removes a process from the ProcessGroup.

			@param process: The process to be removed.
		*/
		public function removeProcess(process:IProcess):void {
			removeProcessListeners(process);

			_hasCompleted = true;

			var l:uint = _processes.length;
            var p:IProcess;
			while (l--) {

                p = _processes[l] as IProcess;
				if (p == process)
					_processes.splice(l, 1);
				else if (!p.completed)
					_hasCompleted = false;
			}
		}

		/**
			Determines if this ProcessGroup contains a specific process.

			@param process: The process to search for.
			@param recursive: If any child of this ProcessGroup is also a ProcessGroup search its children <code>true</code>, or only search this ProcessGroup's children <code>false</code>.
			@return Returns <code>true</code> if the ProcessGroup contains the process; otherwise <code>false</code>.
		*/
		public function hasProcess(process:IProcess, recursive:Boolean = true):Boolean {
			const processFound:Boolean = _processes.indexOf(process) > -1;

			if (!recursive)
				return processFound;

			if (processFound)
				return true;

			var l:uint = _processes.length;
			var p:IProcess;
			var g:ProcessGroup;

			while (l--) {
				p = _processes[l];

				if (p is ProcessGroup) {
					g = p as ProcessGroup;

					if (g.hasProcess(process, true))
						return true;
				}
			}

			return false;
		}

		/**
			The processes that compose the group.
		*/
		public function get processes():Array {
			return _processes.concat();
		}

		/**
			The number of simultaneous processes to run at once.
		*/
		public function get threads():uint {
			return _threads;
		}

		public function set threads(threadAmount:uint):void {
			_threads = threadAmount;
		}

		/**
			Calls {@link Process#destroy destroy} on all processes in the group and removes them from the ProcessGroup.

			@param recursive: If any child of this ProcessGroup is also a ProcessGroup destroy its children <code>true</code>, or only destroy this ProcessGroup's children <code>false</code>.
		*/
		public function destroyProcesses(recursive:Boolean = true):void {
			stop();

			var l:uint = _processes.length;

			if (recursive) {
				var p:Process;
				var g:ProcessGroup;

				while (l--) {
					p = _processes[l];

					if (p is ProcessGroup) {
						g = p as ProcessGroup;
						g.destroyProcesses(true);
					} else
						p.dispose()();
				}
			} else
				while (l--)
					_processes[l].destroy();

			_processes = new Array();
		}

		override public function dispose():void {

            destroyProcesses( true );
			var l:uint = _processes.length;
			while (l--)
				removeProcessListeners(_processes[l]);

			_processes = new Array();

			super.dispose();
		}

		private function checkThreads():void {
			var t:uint = threads;
			var i:int  = -1;
			var p:Process;

			while (++i < _processes.length) {
				if (t == 0)
					return;

				p = _processes[i];

				if (p.running)
					t--;
				else if (!p.completed && running) {
					p.start();
					t--;
				}
			}

			if (t == threads && running)
				onComplete();
		}

		protected function onProcessStopped(e:ProcessEvent):void {
			checkThreads();
		}

		protected function onProcessCompleted(e:ProcessEvent):void {
			checkThreads();
		}

		protected function addProcessListeners(process:IProcess):void {
			process.addEventListener(ProcessEvent.STOP, onProcessStopped);
			process.addEventListener(ProcessEvent.COMPLETE, onProcessCompleted);
		}

		protected function removeProcessListeners(process:IProcess):void {
			process.removeEventListener(ProcessEvent.STOP, onProcessStopped);
			process.removeEventListener(ProcessEvent.COMPLETE, onProcessCompleted);
		}
	}
}