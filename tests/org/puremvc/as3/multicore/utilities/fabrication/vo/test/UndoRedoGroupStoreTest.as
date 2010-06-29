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

package org.puremvc.as3.multicore.utilities.fabrication.vo.test {
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.utils.Stack;
    import org.puremvc.as3.multicore.utilities.fabrication.vo.*;

    /**
     * @author Darshan Sawardekar
     */
    public class UndoRedoGroupStoreTest extends BaseTestCase {

        public var undoRedoGroupStore:UndoRedoGroupStore;

        [Before]
        public function setUp():void
        {
            undoRedoGroupStore = new UndoRedoGroupStore(new Stack(), new Stack());
        }

        [After]
        public function tearDown():void
        {
            undoRedoGroupStore = null;
        }

        [Test]
        public function testUndoRedoGroupStoreHasValidType():void
        {

            assertType(UndoRedoGroupStore, undoRedoGroupStore);
            assertType(IDisposable, undoRedoGroupStore);
        }

        [Test]
        public function testUndoRedoGroupStoreConstructorStoresStacks():void
        {
            var undoStack:Stack = new Stack();
            var redoStack:Stack = new Stack();

            undoRedoGroupStore = new UndoRedoGroupStore(undoStack, redoStack);

            assertEquals(undoStack, undoRedoGroupStore.undoStack);
            assertEquals(redoStack, undoRedoGroupStore.redoStack);
        }

        [Test]
        public function testUndoRedoGroupStoreResetsOnDisposal():void
        {
            var undoStack:Stack = new Stack();
            var redoStack:Stack = new Stack();

            undoRedoGroupStore = new UndoRedoGroupStore(undoStack, redoStack);

            undoRedoGroupStore.dispose();

            assertNull(undoRedoGroupStore.undoStack);
            assertNull(undoRedoGroupStore.redoStack);
        }

    }
}
