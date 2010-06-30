package org.puremvc.as3.multicore.utilities.fabrication.patterns.command {
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.RouteCommandTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.shutdown.ShutdownCommandTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup.StartupCommandTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.test.AsyncFabricationCommandTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.test.SimpleFabricationCommandTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.test.UndoableCommandTestSuite;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class CommandTestSuite {


        public var simpleFabricationCommandTest:SimpleFabricationCommandTest;
        public var asyncFabricationCommandTest:AsyncFabricationCommandTest;

        // routing
        public var routeTestSuite:RouteCommandTestSuite;

        // shutdown
        public var shutdownCommandTestSuite:ShutdownCommandTestSuite;

        // startup
        public var startupCommandTestSuite:StartupCommandTestSuite;

        // undoable
        public var undoableCommandTestSuite:UndoableCommandTestSuite;

    }
}