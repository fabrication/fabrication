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
 
package org.puremvc.as3.multicore.utilities.fabrication {
	import org.puremvc.as3.multicore.utilities.fabrication.components.AllFabricationTests;
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.AllFabricatorTests;
	import org.puremvc.as3.multicore.utilities.fabrication.core.AllFabricationCoreActorTests;
	import org.puremvc.as3.multicore.utilities.fabrication.events.AllFabricationEventsTests;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.AllCommandTests;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.AllFacadeTests;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.AllInterceptorTests;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.AllMediatorTests;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.AllObserverTests;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.AllProxyTests;
	import org.puremvc.as3.multicore.utilities.fabrication.plumbing.AllPlumbingTests;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.AllRoutingTests;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.AllUtilsTests;
	import org.puremvc.as3.multicore.utilities.fabrication.vo.AllValueObjectTests;

	import flexunit.framework.SimpleTestSuite;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationTestSuite extends SimpleTestSuite {

		public function FabricationTestSuite() {
			super();
			
			addTestCase(AllFabricatorTests);
			addTestCase(AllFabricationTests);
			addTestCase(AllFabricationCoreActorTests);
			addTestCase(AllFabricationEventsTests);
			addTestCase(AllCommandTests);
			addTestCase(AllFacadeTests);
			addTestCase(AllMediatorTests);
			addTestCase(AllObserverTests);
			addTestCase(AllProxyTests);
			addTestCase(AllPlumbingTests);
			addTestCase(AllRoutingTests);
			addTestCase(AllUtilsTests);
			addTestCase(AllValueObjectTests);
			addTestCase(AllInterceptorTests);
		}
	}
}
