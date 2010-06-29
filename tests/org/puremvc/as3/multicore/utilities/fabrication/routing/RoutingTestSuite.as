package org.puremvc.as3.multicore.utilities.fabrication.routing {
    import org.puremvc.as3.multicore.utilities.fabrication.routing.firewall.FirewallTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.test.RouterCableListenerTest;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.test.RouterCableTest;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.test.RouterMessageTest;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.test.RouterTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class RoutingTestSuite {

        public var routerTest:RouterTest;
        public var routerMessageTest:RouterMessageTest;
        public var routerCableTest:RouterCableTest;
        public var routerCableListenerTest:RouterCableListenerTest;

        // firewall
        public var firewallTestSuite:FirewallTestSuite;

    }
}