package org.puremvc.as3.multicore.utilities.fabrication.utils {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IHashMap;		

	/**
	 * HashMap is a key-value based storage class. This class should be used along with the
	 * facade based singleton to ensure clean garbage collection once that facade has
	 * been disposed.  
	 * 
	 * TODO : Implement a more complete map api.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class HashMap implements IHashMap {

		/**
		 * Stores the items by their unique key
		 */
		protected var elements:Object;

		/**
		 * Creates a new HashMap object.
		 */
		public function HashMap() {
			elements = new Object();
		}

		/**
         * @inheritDoc
         */
		public function dispose():void {
			var element:Object;
			var key:String;
			for (key in elements) {
				element = elements[key];
				if (element is IDisposable) {
					(element as IDisposable).dispose();
				}
			}

			// explicitly setting to null to help with garbage collection
			// can't do this is the same loop because it introduces a duplicate null key 
			// TODO : File a bug report with Adobe.
			for (key in elements) {
				element = elements[key];
				elements[key] = null;
			}
			
			elements = null;
		}

		/**
         * @inheritDoc
         */
		public function put(key:String, instance:Object):Object {
			elements[key] = instance;
			return instance;
		}

		/**
         * @inheritDoc
         */
		public function find(key:String):Object {
			return elements[key];
		}

		/**
         * @inheritDoc
         */
		public function exists(key:String):Boolean {
			return find(key) != null;
		}

		/**
         * @inheritDoc
         */
		public function remove(key:String):Object {
			var instance:Object = find(key);
			elements[key] = null;
			delete(elements[key]);
			
			return instance;
		}

		/**
         * @inheritDoc
         */
		public function clear():void {
			elements = new Object();
		}
	}
}
