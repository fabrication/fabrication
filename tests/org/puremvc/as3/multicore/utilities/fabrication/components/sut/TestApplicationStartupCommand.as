package org.puremvc.as3.multicore.utilities.fabrication.components.sut {
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;

    public class TestApplicationStartupCommand extends SimpleFabricationCommand {


        override public function execute(notification:INotification):void
        {
            super.execute(notification);
        }
    }
}