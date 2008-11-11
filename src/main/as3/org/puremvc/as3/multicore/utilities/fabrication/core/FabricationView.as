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
	import org.puremvc.as3.multicore.core.View;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	

	/**
	 * FabricationView is the custom view used by fabrication.
	 * It allows for the disposal of all currently registered mediators
	 * at once.
	 * @author Jason MacDonald (Jason.MacDonald@vfmii.com)
	 */
	public class FabricationView extends View implements IDisposable {

		/**
		 * Creates and returns the multiton instance of the view for
		 * the specified multiton key.
		 * 
		 * @param multitonKey The multiton key whose view is to be retrieved.
		 */
		static public function getInstance(multitonKey:String):FabricationView {
			if (instanceMap[multitonKey] == null) {
				instanceMap[multitonKey] = new FabricationView(multitonKey);
			}
			
			return instanceMap[multitonKey] as FabricationView;
		}

		/**
		 * Creates the instance of the FabricationView
		 * 
		 * @param multitonKey The multiton key for this FabricationView
		 */
		public function FabricationView(multitonKey:String) {
			super(multitonKey);
		}

		/**
		 * TODO : improve this using HashMap to store the mediators. 
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			for each(var mediator:IMediator in mediatorMap) {
				if (mediator is IDisposable) {
					(mediator as IDisposable).dispose();
				}
				// check if mediator still exists or it was removed in the dispose call
				if (hasMediator(mediator.getMediatorName())) {
					// removing the mediator also removes it's observerMap references, good to call
					removeMediator(mediator.getMediatorName());
				}
			}
			
			mediatorMap = null;
			removeView(multitonKey);
		}
		
	}		
}
