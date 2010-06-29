package org.puremvc.as3.multicore.utilities.fabrication.components.sut {
    import org.puremvc.as3.multicore.utilities.fabrication.components.FlexHaloApplication;

    public class TestFlexHaloApplication extends FlexHaloApplication {

        override public function getStartupCommand():Class
        {
            return TestApplicationStartupCommand;
        }
    }
}