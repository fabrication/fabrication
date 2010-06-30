package org.puremvc.as3.multicore.utilities.fabrication.addons {
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;

    public class InjectionClientClass {

        public static const NAME:String = "InjectionClientClass_NAME";

        [InjectProxy(name="MyProxy")]
        public var proxyByNameAndType:IProxy;

        [InjectProxy]
        public var proxyByClass:FabricationProxy;

        [InjectMediator(name="MyMediator")]
        public var mediatorByNameAndType:IMediator;

        [InjectMediator]
        public var mediatorByClass:FabricationMediator;


        public function InjectionClientClass()
        {
        }
    }
}