package org.puremvc.as3.multicore.utilities.fabrication.components.sut {
    import org.puremvc.as3.multicore.utilities.fabrication.components.FlashApplication;

    public class TestFlashApplication extends FlashApplication {
        
        override public function getStartupCommand():Class
        {
            return TestApplicationStartupCommand;
        }
    }
}