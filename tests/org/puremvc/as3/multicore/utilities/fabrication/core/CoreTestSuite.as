package org.puremvc.as3.multicore.utilities.fabrication.core {
    import org.puremvc.as3.multicore.utilities.fabrication.core.test.FabricationControllerTest;
    import org.puremvc.as3.multicore.utilities.fabrication.core.test.FabricationModelTest;
    import org.puremvc.as3.multicore.utilities.fabrication.core.test.FabricationViewTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class CoreTestSuite {

            public var fabricationModelTest:FabricationModelTest;
            public var fabricationViewTest:FabricationViewTest;
            public var fabricationControllerTest:FabricationControllerTest;
    }
}