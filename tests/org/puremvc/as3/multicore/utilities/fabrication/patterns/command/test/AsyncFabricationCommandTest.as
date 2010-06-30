package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.test {
    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.ICommandProcessor;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.AsyncFabricationCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.mock.AsyncFabricationCommandMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.mock.AsyncMacroCommandMock;

    public class AsyncFabricationCommandTest extends AbstractFabricationCommandTest {
        private var asyncMacroCommand:AsyncMacroCommandMock;


        override public function createCommand():ICommand
        {
            return new AsyncFabricationCommandMock();
        }

        [Before]
        override public function setUp():void
        {
            super.setUp();
            asyncMacroCommand = new AsyncMacroCommandMock();
        }


        [After]
        override public function tearDown():void
        {
            super.tearDown();
            asyncMacroCommand = null;
        }

        [Test]
        public function asyncFabricationCommandHasValidType():void
        {

            assertType(AsyncFabricationCommand, command);
            assertType(SimpleCommand, command);
            assertType(IDisposable, command);
            assertType(ICommandProcessor, command);
        }

        [Test]
        public function asyncMacroComandOnCompleteTest():void
        {
            AsyncFabricationCommandMock.mock.method("commandComplete").withNoArgs.times( 3 );
            facade.mock.method( "executeCommandClass" ).withArgs( AsyncFabricationCommand ).returns( new AsyncFabricationCommand() );
            asyncMacroCommand.initializeNotifier( instanceName );            
            executeMacroCommand();
            verifyMock( AsyncFabricationCommandMock.mock );
            verifyMock( facade.mock );

        }

        [Test(expects="Error")]
        public function asyncComandErrorOnDirectExecute():void
        {
            executeCommand();
        }


        public function executeMacroCommand(notification:INotification = null):void
        {
            if (notification == null) {
                notification = this.notification;
            }

            asyncMacroCommand.execute(notification);
        }


    }
}