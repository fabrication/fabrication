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
    import org.puremvc.as3.multicore.utilities.fabrication.vo.*;

    /**
     * @author Darshan Sawardekar
     */
    public class NotificationInterestsTest extends BaseTestCase {

        private var noteInterests:NotificationInterests = null;

        [Before]
        public function setUp():void
        {
            noteInterests = new NotificationInterests("foo.bar::MyClass", ["ready"], {ready:"MyProxy"});
        }

        [After]
        public function tearDown():void
        {
            noteInterests.dispose();
        }

        public function testInstantiation():void
        {
            assertType(NotificationInterests, noteInterests);
        }

        [Test]
        public function notificationInterestsStoresClasspath():void
        {
            assertType(String, noteInterests.classpath);
            assertEquals("foo.bar::MyClass", noteInterests.classpath);

            noteInterests.classpath = "test.bar::MyOtherClass";
            assertEquals("test.bar::MyOtherClass", noteInterests.classpath);
        }

        [Test]
        public function notificationInterestsStoresInterests():void
        {
            assertType(Array, noteInterests.interests);
            assertEquals("ready", noteInterests.interests[0]);
            assertEquals(1, noteInterests.interests.length);

            noteInterests.interests = ["foo", "bar"];
            assertEquals("foo", noteInterests.interests[0]);
            assertEquals("bar", noteInterests.interests[1]);
            assertEquals(2, noteInterests.interests.length);
        }

        [Test]
        public function notificationInterestsStoresQualifications():void
        {
            assertType(Object, noteInterests.qualifications);
            assertEquals("MyProxy", noteInterests.qualifications["ready"]);
            assertNull(noteInterests.qualifications["no_such_note"]);

            noteInterests.qualifications["test_note"] = "MyCustomProxy";
            assertEquals("MyCustomProxy", noteInterests.qualifications["test_note"]);
        }

        [Test]
        public function notificationInterestsResetsAfterDisposal():void
        {
            var noteInterests:NotificationInterests = new NotificationInterests(
                    "test.class::ClassName",
                    ["my_note"],
                    {my_note:"MyProxy"}
                    );

            noteInterests.dispose();
            assertNull(noteInterests.classpath);
            assertNull(noteInterests.interests);
            assertNull(noteInterests.qualifications);
        }
    }
}
