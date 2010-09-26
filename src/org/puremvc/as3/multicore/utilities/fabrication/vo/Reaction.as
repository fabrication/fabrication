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
 
package org.puremvc.as3.multicore.utilities.fabrication.vo {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	

	/**
	 * Reaction stores the properties of a Mediator's automatic event handler. It contains the
	 * different parts of Reaction parsed from the reactToComponentEvent convention.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class Reaction implements IDisposable {
		
		/**
		 * The source of this reaction's event
		 */
		public var source:IEventDispatcher;
		
		/**
		 * The name of the event to subscribe to
		 */
		public var eventType:String;
		
		/**
		 * The name of the event handler function to call on reaction fulfilment.
		 */
		public var handler:Function;
		
		/**
		 * Flag indicates whether to use capture phase when subscribing to the event.
		 */
		public var capture:Boolean = false;

		/**
		 * Creates a new Reaction object.
		 * 
		 * @param source The object that will send the event for this Reaction
		 * @param eventType The name of the event to subscribe to.
		 * @param handler The event handler function.
		 * @param capture Optional capture phase of this Reaction.
		 */
		public function Reaction(source:IEventDispatcher, eventType:String, handler:Function, capture:Boolean = false) {
			this.source = source;
			this.eventType = eventType;
			this.handler = handler;
			this.capture = capture;
		}

		/**
         * @inheritDoc
         */
		public function dispose():void {
			stop();
			
			source = null;
			handler = null;
			eventType = null;
		} 
		
		/**
		 * Starts listening to the current event type from the source object.
		 */
		public function start():void {
			source.addEventListener(eventType, fulfil, capture);
		}
		
		/**
		 * Stops listening to the current event type from the source object
		 */
		public function stop():void {
			source.removeEventListener(eventType, fulfil, capture);
		}
		
		/**
		 * The handler function for the current eventType.
		 */
		public function fulfil(event:Event):void {
			handler(event);
		}

        /**
         * Compares current reaction with another one.
         * If they are matched on specified conditions, return true, otherwise false.
         * @param reaction Reaction objecto to compare against
         * @return true or false
         */
        public function compare( reaction:Reaction ):Boolean {

            var theSame:Boolean = true;
            theSame &&= ( source == reaction.source );
            theSame &&= ( eventType == reaction.eventType );

            if( handler == null || reaction.handler == null )
                return theSame;
            theSame &&= ( handler == reaction.handler );
            theSame &&= ( capture == reaction.capture );
            return theSame;
        }
	}
}
