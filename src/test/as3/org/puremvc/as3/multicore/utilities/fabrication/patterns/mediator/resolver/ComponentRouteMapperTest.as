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
	import flexunit.framework.Assert;	
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	
	import flexunit.framework.ModuleAwareTestCase;
	import flexunit.framework.TestSuite;
	
	import mx.events.FlexEvent;
	import mx.modules.Module;	

	/**
	 * @author Darshan Sawardekar
	 */
	dynamic public class ComponentRouteMapperTest extends ModuleAwareTestCase {
		
		static public function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
			var moduleListLoader:ModuleListLoader = ModuleListLoader.getInstance();
			
			var modules:Array = moduleListLoader.modules;
			var n:int = modules.length;
			var module:String;
			
			suite.addTest(new ComponentRouteMapperTest("testComponentRouteMapperHasValidType"));
			
			for (var i:int = 0; i < n; i++) {
				module = modules[i];
				suite.addTest(create(module));
			}			
			
			return suite;
		}
		
		static public function create(moduleUrl:String):ComponentRouteMapperTest {
			return new ComponentRouteMapperTest("testComponentRoutesInModule", moduleUrl);
		}
		
		public var moduleUrl:String;
		
		public function ComponentRouteMapperTest(method:String, moduleUrl:String = null) {
			super(method);
			
			this.moduleUrl = moduleUrl;
		}
		
		public function testComponentRouteMapperHasValidType():void {
			var mapper:ComponentRouteMapper = new ComponentRouteMapper();
			assertType(ComponentRouteMapper, mapper);
			assertType(IDisposable, mapper);
		}
		
		public function testComponentRoutesInModule():void {
			verifyRoutes(moduleUrl);
		}
		
		public function verifyRoutes(url:String):void {
			//trace("verifyRoutes " + url);
			loadModule(url,
				function(event:FlexEvent):void {
					var module:Module = event.target as Module;
					
					assertType(moduleUrl, Module, module);
					assertTrue("Routes property not found in " + moduleUrl, module.hasOwnProperty("routes"));
					
					var routes:Array = module["routes"];
					assertType(moduleUrl, Array, routes);
					assertTrue("Routes array must not be empty in " + moduleUrl, routes.length > 0);
					
					validateRoutesInModule(module, routes);
					removeModule(module);
				}
			);
		}
		
		public function createRouteMapper():ComponentRouteMapper {
			return new ComponentRouteMapper();
		}
		
		public function validateRoutesInModule(module:Module, expectedRoutes:Array):void {
			var mapper:ComponentRouteMapper = createRouteMapper();
			var mappedRoutes:Array = mapper.fetchComponentRoutes(module);
			var expectedRoutesCount:int = expectedRoutes.length;
			var mappedRoutesCount:int = mappedRoutes.length;
			var i:int;
			var expectedRoute:Object;
			var mappedRoute:ComponentRoute;
			
			assertEquals("Invalid mapped routes count.", expectedRoutesCount, mappedRoutesCount);
			
			expectedRoutes.sortOn("id");
			mappedRoutes.sortOn("id");
			
			for (i = 0; i < expectedRoutesCount; i++) {
				expectedRoute = expectedRoutes[i];
				mappedRoute = mappedRoutes[i];
				
				/* *
				trace("Matching " + 
					"expectedRoute(" + expectedRoute.id + ", " + expectedRoute.path + ") vs " +
					"actualRoute(" + mappedRoute.id + ", " + mappedRoute.path + ")"
				);
				/* */

				assertEquals(moduleUrl, expectedRoute.id, mappedRoute.id);
				assertEquals(moduleUrl, expectedRoute.path, mappedRoute.path);
			}
			
			assertTrue(mapper.hasCachedRoutes(module));
			assertEquals(mappedRoutes, mapper.fetchComponentRoutes(module));
		}
		
		private function printRoutes(routes:Array):void {
			var n:int = routes.length;
			trace("Total Routes = " + n);
			
			var route:ComponentRoute;
			for (var i:int = 0; i < n; i++) {
				route = routes[i];
				trace("\t[" + route.id + " : " + route.path + "]");
			}
		}
		

	}
}
