/**
 * Copyright (C) 2008 Darshan Sawardekar.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;

	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.core.UIComponentDescriptor;


	import flash.utils.Dictionary;

    FLEX4::supported {
        import spark.components.Group;
        import mx.core.mx_internal;
        use namespace mx_internal;
    }



	/**
	 * ComponentRouteMapper walks the UIComponentDescriptor tree to
	 * compute the full route to a flex component.
	 *
	 * @author Darshan Sawardekar
	 */
	public class ComponentRouteMapper implements IDisposable {

		private var cachedRoutes:Dictionary;

		public function ComponentRouteMapper() {
			cachedRoutes = new Dictionary(true);
		}

		public function dispose():void {
			cachedRoutes = null;
		}

		public function fetchComponentRoutes(component:UIComponent, path:String = ""):Array {
			if (hasCachedRoutes(component)) {
				return getCachedRoutes(component);
			} else {
				var routes:Array = mapComponentRoutes(component, path);
				cachedRoutes[component] = routes;
				//printRoutes(routes);
				return routes;
			}
		}

		public function mapComponentRoutes(component:UIComponent, path:String = ""):Array {
			var routes:Array = new Array();
			var childDescriptors:Array;
			var childDescriptor:UIComponentDescriptor;
			var id:String;
			var childPath:String = "";
            var mxmlContent:Array;


            FLEX4::supported {
                if (component is Group) {


                    var groupBase:Group = component as Group;
                    mxmlContent = groupBase.mx_internal::getMXMLContent();
                    if (mxmlContent && mxmlContent.length) {

                        routes.push.apply(this, calcRoutesFromMXMLContent(mxmlContent, path));

                    }

                    return routes;

                }
            }

			if (component is Container) {
				var container:Container = component as Container;
				childDescriptors = container.childDescriptors;
				id = component.id != null ? component.id : component.name;

				if (childDescriptors != null) {
					routes.push.apply(this, calcRoutesFromDescriptors(childDescriptors, path));
				}
            }


            else {
				childDescriptor = component.descriptor;
				if (childDescriptor != null && childDescriptor.id != null) {
					id = childDescriptor.id;
					childPath = path != "" ? path + "." + id : id;

					routes.push(new ComponentRoute(id, childPath));
				}
			}

			return routes;
		}

		public function hasCachedRoutes(component:UIComponent):Boolean {
			var routes:Array = getCachedRoutes(component);
			return routes != null && routes.length > 0;
		}

		public function getCachedRoutes(component:UIComponent):Array {
			return cachedRoutes[component];
		}

		public function clearCachedRoute(component:UIComponent):void {
			delete(cachedRoutes[component]);
		}

		private function calcRoutesFromDescriptors(childDescriptors:Array, path:String = ""):Array {
			var routes:Array = new Array();
			var propertiesFactory:Function;
			var n:int = childDescriptors.length;
			var childDescriptor:UIComponentDescriptor;
			var childPath:String;
			var id:String;
			var nestedChildDescriptors:Array;
            var mxmlContent:Array;

			for (var i:int = 0;i < n; i++) {
				childDescriptor = childDescriptors[i];
				id = childDescriptor.id;

				if (id != null) {
					childPath = path != "" ? path + "." + id : id;
				} else {
					childPath = path != "" ? path + "." + i : String(i);
				}

				if (id != null) {
					routes.push(new ComponentRoute(id, childPath));
				}

				propertiesFactory = childDescriptor.propertiesFactory;

				if (propertiesFactory != null) {
					nestedChildDescriptors = propertiesFactory().childDescriptors;
					if (nestedChildDescriptors != null && nestedChildDescriptors.length > 0) {
						routes.push..apply(this, calcRoutesFromDescriptors(nestedChildDescriptors, childPath));
					}
                    else {

                        mxmlContent = childDescriptor.properties['mxmlContent'];
                        if (mxmlContent && mxmlContent.length) {

                            routes.push..apply(this, calcRoutesFromMXMLContent(mxmlContent, childPath));

				}


			}
                }
            }

			return routes;
		}

        private function calcRoutesFromMXMLContent(mxmlContent:Array, path:String = ""):Array
        {


            var routes:Array = [];
            var n:int = mxmlContent.length;
            var component:UIComponent;
            var childPath:String;
            var id:String;

            for (var i:int = 0; i < n; ++i) {

                component = mxmlContent [ i ] as UIComponent;
                id = component.id;
                if (id != null) {
                    childPath = path != "" ? path + "." + id : id;
                }
                else {
                    childPath = path != "" ? path + "." + i : String(i);
                }

                if (id != null) {
                    routes.push(new ComponentRoute(id, childPath));
                }


                routes.push..apply(this, mapComponentRoutes(component, childPath));


            }

            return routes;

        }

		/* *
		private function printRoutes(routes:Array):void {
			var n:int = routes.length;
			trace("Mapped Routes = " + n);

			var route:Object;
			for (var i:int = 0; i < n; i++) {
				route = routes[i];
				trace("\t[" + route.id + " : " + route.path + "]");
			}
		}
		/* */
	}
}
