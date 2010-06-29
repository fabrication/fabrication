package org.puremvc.as3.multicore.utilities.fabrication.patterns.observer {
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.test.FabricationNotificationTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.test.RouterNotificationTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.test.TransportNotificationTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.test.UndoableNotificationTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class ObserverTestSuite {

        public var fabricationNotificationTest:FabricationNotificationTest;
        public var routerNotificationTest:RouterNotificationTest;
        public var transportNotificationTest:TransportNotificationTest;
        public var undoableNotificationTest:UndoableNotificationTest;

    }
}