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
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
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
		 * Saves the object in the specified key in the hash map.
		 * 
		 * @param key The unique key to save the object in.
		 * @param instance The object to save with the key.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IHashMap#put()
		 */
		public function put(key:String, instance:Object):Object {
			elements[key] = instance;
			return instance;
		}

		/**
		 * Retrieves the object for the key specified.
		 * 
		 * @param key The unique key whose object is to be retrieved.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IHashMap#find()
		 */
		public function find(key:String):Object {
			return elements[key];
		}

		/**
		 * Returns a boolean indicating whether an object with the key exists.
		 * 
		 * @param key The unique key whose object is to be looked up.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IHashMap#exists()
		 */
		public function exists(key:String):Boolean {
			return find(key) != null;
		}

		/**
		 * Removes the object stored in the specified key and returns it.
		 * 
		 * @param key The unique key whose object is to be removed.
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IHashMap#put()
		 */
		public function remove(key:String):Object {
			var instance:Object = find(key);
			elements[key] = null;
			delete(elements[key]);
			
			return instance;
		}

		/**
		 * Clears the hashmap of all objects. 
		 */
		public function clear():void {
			elements = new Object();
		}
	}
}
