package org.puremvc.as3.multicore.utilities.fabrication.addons {
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    import org.flexunit.runner.external.ExternalDependencyToken;
    import org.flexunit.runner.external.IExternalDependencyLoader;

    public class ComponentsDataProvider implements IExternalDependencyLoader{


        private var _token:ExternalDependencyToken;
        private var _url:String;
        private var _loader:URLLoader;

        public function ComponentsDataProvider( url:String )
        {
            _url = url;
            _token = new ExternalDependencyToken();
            _loader = new URLLoader();
            _loader.addEventListener(Event.COMPLETE, xmlLoaderCompleteHandler );
        }

        private function xmlLoaderCompleteHandler( event:Event ):void
        {
            var arr:Array = [];
            var list:XMLList = new XMLList( new XML( (event.target as URLLoader).data as String ).module );
            for each( var xmlData:XML in list ) {

                arr.push( [ ""+xmlData.@path ] );


            }
            _token.notifyResult( arr );

        }

        public function retrieveDependency(testClass:Class):ExternalDependencyToken
        {
            _loader.load(new URLRequest( _url ));
            return _token;
        }
    }
}