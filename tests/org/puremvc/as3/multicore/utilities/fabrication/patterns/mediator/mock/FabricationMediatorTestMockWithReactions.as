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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock {
    import flash.events.Event;

    import mx.core.UIComponent;

    /**
	 * @author Darshan Sawardekar
	 */
	public class FabricationMediatorTestMockWithReactions extends FabricationMediatorTestMock {
		
		public function FabricationMediatorTestMockWithReactions(name:String = null, viewComponent:Object = null) {
			super(name, viewComponent);
		}
		
		public function getReactionHandlerPrefix():String {
			return reactionHandlerPrefix;
		}
		
		public function getCaptureHandlerPrefix():String {
			return captureHandlerPrefix;
		}

		public function get myButton():UIComponent {
			return viewComponent.myButton as UIComponent;
		}

		public function reactToMyButtonClick(event:Event):void {
			mock.reactToMyButtonClick(event);
		}

		public function reactToMyButtonMouseDown(event:Event):void {
			mock.reactToMyButtonMouseDown(event);
		}

		public function reactToMyButtonMouseUp(event:Event):void {
			mock.reactToMyButtonMouseUp(event);
		}

		public function reactToMyButtonCustomEvent(event:Event):void {
			mock.reactToMyButtonCustomEvent(event);
		}
		
		public function trapMyButtonChildAdd(event:Event):void {
			mock.trapMyButtonChildAdd(event);
		}

		public function trapMyButtonBarEvent(event:Event):void {
			mock.trapMyButtonBarEvent(event);
		}
		
		public function reactToMyButtonCLICK(event:Event):void {
			mock.reactToMyButtonCLICK(event);
		}

		public function reactToMyButtonMOUSE_DOWN(event:Event):void {
			mock.reactToMyButtonMOUSE_DOWN(event);
		}

		public function reactToMyButtonMOUSE_UP(event:Event):void {
			mock.reactToMyButtonMOUSE_UP(event);
		}

		public function reactToMyButtonCUSTOM_EVENT(event:Event):void {
			mock.reactToMyButtonCUSTOM_EVENT(event);
		}

        public function reactToMyButton$CustomEvent( event:Event ):void {
            mock.reactToMyButton$CustomEvent(event);
        }

        public function reactToMyButton$CUSTOM_EVENT( event:Event ):void {
            mock.reactToMyButton$CUSTOM_EVENT(event);
        }

        public function reactToMyButton$MouseUp( event:Event ):void {
            mock.reactToMyButton$MouseUp(event);
        }
        
        public function reactToMyButton$MOUSE_UP( event:Event ):void {
            mock.reactToMyButton$MOUSE_UP(event);
        }


		public function getReactions():Array {
			return currentReactions;
		}

		
	}
}
