package org.puremvc.as3.multicore.utilities.fabrication.process {

    import flash.events.IEventDispatcher;

    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;


    public interface IProcess extends IDisposable,  IEventDispatcher{


        function start():void;
        function stop():void;
        function get running():Boolean;
        function get completed():Boolean;

    }
}