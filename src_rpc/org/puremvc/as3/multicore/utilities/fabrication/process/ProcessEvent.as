package org.puremvc.as3.multicore.utilities.fabrication.process {
    import flash.events.Event;

    public class ProcessEvent extends Event {

        public static const START:String = 'processStart';
        public static const STOP:String = 'processStop';
        public static const COMPLETE:String = 'processComplete';
        public static const PROGRESS:String = 'processProgress';

        public var progress:Number = NaN;

        public function ProcessEvent(type:String, progress:Number = NaN )
        {
            super(type, bubbles, cancelable);
            if( type == START || type == STOP )
                this.progress = 0;
            else if( type == COMPLETE )
                this.progress = 1;
            else
            this.progress = progress;
        }

        override public function clone():Event
        {
            return new ProcessEvent(type, progress );
        }
    }
}