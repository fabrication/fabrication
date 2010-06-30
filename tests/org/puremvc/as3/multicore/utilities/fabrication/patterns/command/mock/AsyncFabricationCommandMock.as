package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.mock {
    import com.anywebcam.mock.Mock;

    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.AsyncFabricationCommand;

    public class AsyncFabricationCommandMock extends AsyncFabricationCommand {

        private static var _mock:Mock;

        static public function get mock():Mock
        {
            return _mock ? _mock : _mock = new Mock(AsyncFabricationCommand, true);
        }


        override public function execute(notification:INotification):void
        {
            super.execute(notification);
            commandComplete();
        }

        override protected function commandComplete():void
        {
            super.commandComplete();
            mock.commandComplete();
        }
    }
}