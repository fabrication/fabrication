package org.puremvc.as3.multicore.utilities.fabrication.process {
    import flash.events.EventDispatcher;


    [Event(name="processStart", type="org.puremvc.as3.multicore.utilities.fabrication.process.ProcessEvent")]
    [Event(name="processStop", type="org.puremvc.as3.multicore.utilities.fabrication.process.ProcessEvent")]
    [Event(name="processComplete", type="org.puremvc.as3.multicore.utilities.fabrication.process.ProcessEvent")]

    public class Process extends EventDispatcher implements IProcess {


        protected var _running:Boolean = false;
        protected var _hasCompleted:Boolean = false;


        public function start():void
        {
            _running = true;
            _hasCompleted = false;
            dispatchEvent(new ProcessEvent(ProcessEvent.START));
        }

        public function stop():void
        {
            dispatchEvent(new ProcessEvent(ProcessEvent.STOP));
            _running = false;
        }

        public function get running():Boolean
        {
            return _running;
        }

        public function get completed():Boolean
        {
            return _hasCompleted;
        }

        public function dispose():void
        {
            if (_running)
                stop();

        }

        protected function onProgress(progress:Number):void
        {

            dispatchEvent(new ProcessEvent(ProcessEvent.PROGRESS, progress));
        }

        protected function onComplete():void
        {

            _running = false;
            _hasCompleted = true;
            dispatchEvent(new ProcessEvent(ProcessEvent.COMPLETE));

        }


    }
}