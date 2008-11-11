package org.puremvc.as3.multicore.utilities.fabrication.interfaces {

	/**
	 * IHashMap is the interface for an object that maps key names to values.
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IHashMap extends IDisposable {
		
		/**
		 * Associates the specified value with the specified key in this hash map.
		 */
		function put(key:String, value:Object):Object
		
		/**
		 * Retrives the value for the specified key in this hash map.
		 */
		function find(key:String):Object;
		
		/**
		 * Returns a boolean based on whether this hash map has value for the specified key.
		 */
		function exists(key:String):Boolean;
		
		/**
		 * Removes the specified key from this hash map. 
		 */
		function remove(key:String):Object;
		
		/**
		 * Removes all mappings from this hash map.
		 */
		function clear():void;
		
	}
}
