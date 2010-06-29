package org.puremvc.as3.multicore.utilities.fabrication.components.fabricator {
    import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.test.ApplicationFabricatorTest;
    import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.test.FlashApplicationFabricatorTest;
    import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.test.FlexApplicationFabricatorTest;
    import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.test.FlexModuleFabricatorTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class FabricatorTestSuite {


        public var applicationFabricatorTest:ApplicationFabricatorTest;
        public var flashApplicationFabricatorTest:FlashApplicationFabricatorTest;
        public var flexApplicationFabricatorTest:FlexApplicationFabricatorTest;
        public var flexModuleFabricatorTest:FlexModuleFabricatorTest;


    }
}