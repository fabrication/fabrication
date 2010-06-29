package org.puremvc.as3.multicore.utilities.fabrication.addons {
    import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModule;
    import org.puremvc.as3.multicore.utilities.fabrication.components.sut.TestApplicationStartupCommand;

    public class TestFlexModule extends FlexModule {

        override public function getStartupCommand():Class
        {
            return TestApplicationStartupCommand;
        }
    }
}