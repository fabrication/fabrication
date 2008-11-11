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
 
package org.puremvc.as3.multicore.utilities.fabrication.utils {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IHashMap;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.DisposableMock;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class HashMapTest extends SimpleTestCase {
		
		private var hashMap:HashMap;
		
		public function HashMapTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			hashMap = new HashMap();
		}
		
		override public function tearDown():void {
			hashMap.dispose();
			hashMap = null;
		}
		
		public function testHashMapHasValidType():void {
			assertType(HashMap, hashMap);
			assertType(IHashMap, hashMap);
			assertType(IDisposable, hashMap);
		}
		
		public function testHashMapStoresObjects():void {
			assertDoesNotThrow(Error);
			
			hashMap.put("a", "a");
			hashMap.put("b", 0);
			hashMap.put("c", new Date());
			hashMap.put("d", new Object());
			hashMap.put("e", new HashMapTest("testHashMapStoresObjects"));
		}
		
		public function testHashMapReturnsValidStoredObjects():void {
			var expected:Array = new Array();
			var actual:Array = new Array();
			var sampleSize:int = 25;
			var i:int = 0;
			var instance:Object;
			
			for (i = 0; i < sampleSize; i++) {
				instance = new Object();
				instance.value = i;
				
				expected.push(instance);
				hashMap.put(i.toString(), instance);
				actual.push(hashMap.find(i.toString()));
			}
			
			assertArrayEquals(expected, actual);
		}
		
		public function testHashMapReturnsValidKeyExistence():void {
			var sampleSize:int = 25;
			var i:int = 0;
			var instance:Object;
			
			for (i = 0; i < sampleSize; i++) {
				instance = new Object();
				instance.value = i;
				
				hashMap.put(i.toString(), instance);
				assertTrue(hashMap.exists(i.toString()));
				assertFalse(hashMap.exists("no_such_key" + i));
			}
		}
		
		public function testHashMapRemovesKeyFromStore():void {
			var sampleSize:int = 25;
			var i:int = 0;
			var instance:Object;
			
			for (i = 0; i < sampleSize; i++) {
				instance = new Object();
				instance.value = i;
				
				hashMap.put(i.toString(), instance);
				assertTrue(hashMap.exists(i.toString()));
				
				assertEquals(instance, hashMap.remove(i.toString()));
				assertFalse(hashMap.exists(i.toString()));
			}			
		}
		
		public function testHashMapInvokesDisposeOnStoredObjectOnDisposal():void {
			var hashMap:HashMap = new HashMap();			
			var instance:DisposableMock;
			var instancesList:Array = new Array();
			var sampleSize:int = 25;
			var i:int = 0;
			
			for (i = 0; i < sampleSize; i++) {
				instance = new DisposableMock();
				instance.mock.method("dispose").withNoArgs.once;
				instancesList.push(instance);
				
				hashMap.put(i.toString(), instance);
				assertTrue(hashMap.exists(i.toString()));
				assertType(DisposableMock, hashMap.find(i.toString()));
			}			
			
			hashMap.dispose();
			
			for (i = 0; i < sampleSize; i++) {
				instance = instancesList[i];
				verifyMock(instance.mock);
			}
		}
		
	}
}
