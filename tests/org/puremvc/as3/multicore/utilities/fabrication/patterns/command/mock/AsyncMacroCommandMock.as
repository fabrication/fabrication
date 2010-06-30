package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.mock {
    import com.anywebcam.mock.Mock;

    import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
    import org.puremvc.as3.multicore.patterns.command.MacroCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.IMockable;

    public class AsyncMacroCommandMock extends AsyncMacroCommand implements IMockable  {

        private var _mock:Mock;
        

        override protected function initializeAsyncMacroCommand():void
        {
            super.initializeAsyncMacroCommand();
            addSubCommand( AsyncFabricationCommandMock );
            addSubCommand( AsyncFabricationCommandMock );
            addSubCommand( AsyncFabricationCommandMock );
        }

        public function get mock():Mock
        {
            return _mock ? _mock : _mock = new Mock();
        }

        
    }
}