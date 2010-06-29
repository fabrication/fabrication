package org.puremvc.as3.multicore.utilities.fabrication.components.sut {
    import org.puremvc.as3.multicore.utilities.fabrication.components.FlexApplication;

    public class TestFlexApplication extends FlexApplication {

        override public function getStartupCommand():Class
        {
            return TestApplicationStartupCommand;
        }
    }
}