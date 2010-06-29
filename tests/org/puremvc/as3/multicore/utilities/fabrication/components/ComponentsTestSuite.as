package org.puremvc.as3.multicore.utilities.fabrication.components {
    import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.FabricatorTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.components.test.FlashApplicationTest;
    import org.puremvc.as3.multicore.utilities.fabrication.components.test.FlexApplicationTest;
    import org.puremvc.as3.multicore.utilities.fabrication.components.test.FlexModuleLoaderTest;
    import org.puremvc.as3.multicore.utilities.fabrication.components.test.FlexModuleTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class ComponentsTestSuite {

        public var flashApplicationTest:FlashApplicationTest;
        public var flexApplicationTest:FlexApplicationTest;
        public var flexModuleTest:FlexModuleTest;

        // FIXME:: Rafał Szemraj, [ Jun 28, 2010 ], have to fix FlexModuleLoader test 
        //public var flexModuleLoaderTest:FlexModuleLoaderTest;

        // fabricator
        public var fabricatorTestSuite:FabricatorTestSuite;
    }
}