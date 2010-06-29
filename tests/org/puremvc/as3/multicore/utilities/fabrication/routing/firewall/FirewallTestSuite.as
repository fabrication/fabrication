package org.puremvc.as3.multicore.utilities.fabrication.routing.firewall {
    import org.puremvc.as3.multicore.utilities.fabrication.routing.firewall.test.MultiRuleFirewallTest;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.firewall.test.PolicyFirewallTest;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.firewall.test.ReservedNotificationRuleTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class FirewallTestSuite {

        public var policyFirewallTest:PolicyFirewallTest;
        public var reservedNotificationRuleTest:ReservedNotificationRuleTest;
        public var multiRuleFirewallTest:MultiRuleFirewallTest;
    }
}