package org.puremvc.as3.multicore.utilities.fabrication.interfaces {

	/**
	 * IRouterMessageStore is the interface that indicates the ability to store
	 * router messages.
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IRouterMessageStore {
		
		/**
		 * Returns the current stored router message object.
		 */
		function getMessage():IRouterMessage;
		
		/**
		 * Saves the specified router message
		 * 
		 * @param message The message to store
		 */ 
		function setMessage(message:IRouterMessage):void;
		
	}
}
