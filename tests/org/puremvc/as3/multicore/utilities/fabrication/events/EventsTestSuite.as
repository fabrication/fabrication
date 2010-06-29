package org.puremvc.as3.multicore.utilities.fabrication.events {
    import org.puremvc.as3.multicore.utilities.fabrication.events.test.ComponentResolverEventTest;
    import org.puremvc.as3.multicore.utilities.fabrication.events.test.FabricatorEventTest;
    import org.puremvc.as3.multicore.utilities.fabrication.events.test.MediatorRegistrarEventTest;
    import org.puremvc.as3.multicore.utilities.fabrication.events.test.NotificationProcessorEventTest;
    import org.puremvc.as3.multicore.utilities.fabrication.events.test.RouterFirewallEventTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class EventsTestSuite {

        public var fabricationEventTest:FabricatorEventTest;
        public var notificationProcessEventtest:NotificationProcessorEventTest;
        public var mediatorRegistrationEventtest:MediatorRegistrarEventTest;
        public var routerFirewallEventTest:RouterFirewallEventTest;
        public var componentresolverEventTest:ComponentResolverEventTest;

    }
}