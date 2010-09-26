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
 
package org.puremvc.as3.multicore.utilities.fabrication.core {
	import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;	
	import org.puremvc.as3.multicore.interfaces.IProxy;	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	import org.puremvc.as3.multicore.core.Model;	

	/**
	 * FabricationModel is the custom model implementation used internally
	 * by fabrication.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FabricationModel extends Model implements IDisposable {

		/**
		 * Creates and returns the instance of the FabricationModel for the specified 
		 * multiton key.
		 * 
		 * @param multitonKey The multitonkey whose FabricationModel is to be created.
		 */
		static public function getInstance(multitonKey:String):FabricationModel {
			if (instanceMap[multitonKey] == null) {
				instanceMap[multitonKey] = new FabricationModel(multitonKey);
			}
			
			return instanceMap[multitonKey] as FabricationModel;
		}

		/**
		 * Stores the proxies in this model in a hash map.
		 */
		protected var proxyHashMap:HashMap;

		/**
		 * Creates the FabricationModel instance.
		 * 
		 * @param multitonKey The multitonkey for this FabricationModel
		 */
		public function FabricationModel(multitonKey:String) {
			super(multitonKey);
			
			proxyHashMap = new HashMap();
		}

		/**
		 * @see org.puremvc.as3.multicore.interfaces.IModel#registerProxy()
		 */
		override public function registerProxy(proxy:IProxy):void {
			proxy.initializeNotifier(multitonKey);
			proxyHashMap.put(proxy.getProxyName(), proxy);
			proxy.onRegister();
		}

		/**
		 * @see org.puremvc.as3.multicore.interfaces.IProxy#retrieveProxy()
		 */
		override public function retrieveProxy(proxyName:String):IProxy {
			return proxyHashMap.find(proxyName) as IProxy;
		}

		/**
		 * @see org.puremvc.as3.multicore.interfaces.IModel#hasProxy()
		 */
		override public function hasProxy(proxyName:String):Boolean {
			return proxyHashMap.exists(proxyName);
		}

		/**
		 * @see org.puremvc.as3.multicore.interfaces.IModel#removeProxy()
		 */
		override public function removeProxy(proxyName:String):IProxy {
			var proxy:IProxy = proxyHashMap.remove(proxyName) as IProxy;
			proxy.onRemove();
			
			return proxy;
		}
		
		/**
         * @inheritDoc
         */
		public function dispose():void {
			proxyHashMap.dispose();
			proxyHashMap = null;
			
			removeModel(multitonKey);
		}
	}
}
