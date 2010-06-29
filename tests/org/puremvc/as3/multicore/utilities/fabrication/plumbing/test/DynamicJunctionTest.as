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

package org.puremvc.as3.multicore.utilities.fabrication.plumbing.test {
    import com.anywebcam.mock.Mock;

    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.plumbing.*;
    import org.puremvc.as3.multicore.utilities.fabrication.plumbing.mock.NamedPipeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.plumbing.mock.PipeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMessage;
    import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
    import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;

    /**
     * @author Darshan Sawardekar
     */
    public class DynamicJunctionTest extends BaseTestCase {

        /* *
         static public function suite():TestSuite {
         var suite:TestSuite = new TestSuite();
         suite.addTest(new DynamicJunctionTest("testDynamicJunctionCanSendMessageToClassInstanceWithinModuleGroup"));

         return suite;
         }
         /* */

        protected var dynamicJunction:DynamicJunction = null;
        protected var mock:Mock;
        protected var pipe:PipeMock;
        protected var message:RouterMessage;

        [Before]
        public function setUp():void
        {
            dynamicJunction = new DynamicJunction();
        }

        [After]
        public function tearDown():void
        {
            dynamicJunction.dispose();
            dynamicJunction = null;
        }

        protected function verifyDynamicJunctionCanSendMessageWith(destName:String, pipeName:String, fromModuleRoute:String = "A/A0", toModuleRoute:String = "B/B0", message:RouterMessage = null):void
        {
            if (message == null) {
                message = new RouterMessage(Message.NORMAL, null, fromModuleRoute + "/OUTPUT", toModuleRoute + "/INPUT");
            }

            pipe = new PipeMock();
            mock = pipe.mock;
            this.message = message;

            mock.method("write").withArgs(message).returns(true);
            dynamicJunction.registerPipe(pipeName, Junction.OUTPUT, pipe);

            dynamicJunction.sendMessage(destName, message);
        }

        [Test]
        public function testDynamicJunctionHasValidType():void
        {
            assertType(DynamicJunction, dynamicJunction);
            assertType(Junction, dynamicJunction);
            assertType(IDisposable, dynamicJunction);
        }

        [Test]
        public function testDynamicJunctionCanSendMessageToAll():void
        {
            var fromModuleRoute:String = "A/A0";
            var toModuleName:String = "B";
            var toInstanceName:String;

            var pipe:PipeMock;
            var pipeName:String;
            var mock:Mock;
            var i:int = 0;
            var sampleSize:int = 25;
            var pipeList:Array = new Array();
            var message:RouterMessage = new RouterMessage(Message.NORMAL, null, fromModuleRoute + "/OUTPUT");

            for (i = 0; i < sampleSize; i++) {
                pipe = new PipeMock();
                mock = pipe.mock;
                toInstanceName = toModuleName + "/" + toModuleName + i;
                pipeName = toInstanceName + "/INPUT";

                mock.method("write").withArgs(message).returns(true);
                dynamicJunction.registerPipe(pipeName, Junction.OUTPUT, pipe);

                pipeList.push(pipe);
            }

            dynamicJunction.sendMessage("*", message);

            for (i = 0; i < sampleSize; i++) {
                pipe = pipeList[i];
                assertEquals(message, pipe.message);
            }
        }

        [Test]
        public function testDynamicJunctionCanSendMessageToAllInstances():void
        {
            var fromModuleRoute:String = "A/A0";
            var toModuleName:String = "B";
            var toInstanceName:String;

            var pipe:PipeMock;
            var pipeName:String;
            var mock:Mock;
            var i:int = 0;
            var sampleSize:int = 25;
            var pipeList:Array = new Array();
            var message:RouterMessage = new RouterMessage(Message.NORMAL, null, fromModuleRoute + "/OUTPUT");

            for (i = 0; i < sampleSize; i++) {
                pipe = new PipeMock();
                mock = pipe.mock;
                toInstanceName = toModuleName + "/" + toModuleName + i;
                pipeName = toInstanceName + "/INPUT";

                mock.method("write").withArgs(message).returns(true);
                dynamicJunction.registerPipe(pipeName, Junction.OUTPUT, pipe);

                pipeList.push(pipe);
            }

            dynamicJunction.sendMessage(toModuleName + "/*", message);

            for (i = 0; i < sampleSize; i++) {
                pipe = pipeList[i];
                assertEquals(message, pipe.message);
            }
        }

        [Test]
        public function testDynamicJunctionDropsLoopbackMessage():void
        {
            var fromModuleRoute:String = "A/A0";
            var toModuleRoute:String = fromModuleRoute;
            var destName:String = "*";
            var pipeName:String = toModuleRoute + "/INPUT";

            verifyDynamicJunctionCanSendMessageWith(destName, pipeName, fromModuleRoute, toModuleRoute);
            assertNull(message, pipe.message);
        }

        [Test]
        public function testDynamicJunctionModuleGroupRegularExpressionIsValid():void
        {
            var re:RegExp = DynamicJunction.MODULE_GROUP_REGEXP;

            assertMatch(re, "myGroup");
            assertMatch(re, "MyGroupName");
            assertMatch(re, "my-group-name");

            assertNoMatch(re, "A/A0");
            assertNoMatch(re, "A/A/OUTPUT");
            assertNoMatch(re, "A/*");
            assertNoMatch(re, "*");
        }

        [Test]
        public function testDynamicJunctionModuleGroupCheckerIsValid():void
        {
            assertTrue(dynamicJunction.isModuleGroup("myGroup"));
            assertTrue(dynamicJunction.isModuleGroup("MyGroupName"));
            assertTrue(dynamicJunction.isModuleGroup("foo-bar"));

            assertFalse(dynamicJunction.isModuleGroup("A/A0"));
            assertFalse(dynamicJunction.isModuleGroup("A/*"));
            assertFalse(dynamicJunction.isModuleGroup("A/A0/OUTPUT"));
            assertFalse(dynamicJunction.isModuleGroup("*"));

            assertFalse(dynamicJunction.isModuleGroup(null));
            assertFalse(dynamicJunction.isModuleGroup(""));
        }

        [Test]
        public function testDynamicJunctionCanSendMessageToGroups():void
        {
            var sampleSize:int = 25;
            var outputPipe:NamedPipeMock;
            var message:RouterMessage = new RouterMessage(Message.NORMAL, null, "X/X0/OUTPUT");
            var i:int;
            var pipesList:Array = new Array();

            for (i = 0; i < sampleSize; i++) {
                outputPipe = new NamedPipeMock("A/A" + i + "/OUTPUT");
                outputPipe.mock.method("getName").returns("A/A" + i + "/OUTPUT");
                outputPipe.mock.property("moduleGroup").returns(instanceName);

                dynamicJunction.registerPipe(outputPipe.getName(), Junction.OUTPUT, outputPipe);
                pipesList.push(outputPipe);
            }

            for (i = 0; i < sampleSize; i++) {
                outputPipe = pipesList[i];
                assertNull(outputPipe.message);
            }

            dynamicJunction.sendMessage(instanceName, message);

            for (i = 0; i < sampleSize; i++) {
                outputPipe = pipesList[i];
                assertEquals(outputPipe.message, message);
            }
        }

        [Test]
        public function testDynamicJunctionDoesNotSendMessageToGroupsAfterRemoval():void
        {
            var sampleSize:int = 30;
            var outputPipe:NamedPipeMock;
            var message:RouterMessage = new RouterMessage(Message.NORMAL, null, "X/X0/OUTPUT");
            var i:int;
            var pipesList:Array = new Array();

            for (i = 0; i < sampleSize; i++) {
                outputPipe = new NamedPipeMock("A/A" + i + "/OUTPUT");
                outputPipe.mock.method("getName").returns("A/A" + i + "/OUTPUT");
                outputPipe.mock.property("moduleGroup").returns(instanceName);

                dynamicJunction.registerPipe(outputPipe.getName(), Junction.OUTPUT, outputPipe);
                pipesList.push(outputPipe);
            }

            for (i = 0; i < 10; i++) {
                outputPipe = pipesList[i];
                dynamicJunction.removePipe(outputPipe.getName());
            }

            dynamicJunction.sendMessage(instanceName, message);

            for (i = 0; i < sampleSize; i++) {
                outputPipe = pipesList[i];
                if (i < 10) {
                    assertNull(outputPipe.message);
                }
                else {
                    assertEquals(outputPipe.message, message);
                }
            }
        }

        [Test]
        public function testDynamicJunctionIgnoresGroupMessageWithoutNamedPipesWithGroups():void
        {
            var sampleSize:int = 25;
            var outputPipe:NamedPipeMock;
            var message:RouterMessage = new RouterMessage(Message.NORMAL, null, "X/X0/OUTPUT");
            var i:int;
            var pipesList:Array = new Array();

            for (i = 0; i < sampleSize; i++) {
                outputPipe = new NamedPipeMock("A/A" + i + "/OUTPUT");
                outputPipe.mock.method("getName").returns("A/A" + i + "/OUTPUT");
                outputPipe.mock.property("moduleGroup").returns(null);

                dynamicJunction.registerPipe(outputPipe.getName(), Junction.OUTPUT, outputPipe);
                pipesList.push(outputPipe);
            }

            assertFalse(dynamicJunction.sendMessage(instanceName, message));

            for (i = 0; i < sampleSize; i++) {
                outputPipe = pipesList[i];
                assertNull(outputPipe.message);
            }
        }

        [Test]
        public function testDynamicJunctionCanSendMessageToClassInstanceWithinModuleGroup():void
        {
            var sampleSize:int = 25;
            var outputPipe:NamedPipeMock;
            var message:RouterMessage = new RouterMessage(Message.NORMAL, null, "X/X0/OUTPUT");
            var i:int;
            var pipesList:Array = new Array();

            for (i = 0; i < sampleSize; i++) {
                outputPipe = new NamedPipeMock("A/A" + i + "/OUTPUT");
                outputPipe.mock.method("getName").returns("A/A" + i + "/OUTPUT");
                outputPipe.mock.property("moduleGroup").returns(instanceName);

                dynamicJunction.registerPipe(outputPipe.getName(), Junction.OUTPUT, outputPipe);
                pipesList.push(outputPipe);
            }

            var j:int;
            for (i = 0; i < sampleSize; i++) {
                j = sampleSize + i;
                outputPipe = new NamedPipeMock("A/A" + j + "/OUTPUT");
                outputPipe.mock.method("getName").returns("A/A" + j + "/OUTPUT");
                outputPipe.mock.property("moduleGroup").returns(instanceName + "B");

                dynamicJunction.registerPipe(outputPipe.getName(), Junction.OUTPUT, outputPipe);
                pipesList.push(outputPipe);
            }

            assertTrue(dynamicJunction.sendMessage("A/#" + instanceName, message));

            var n:int = pipesList.length;
            for (i = 0; i < n; i++) {
                outputPipe = pipesList[i];
                if (i < sampleSize) {
                    assertEquals(message, outputPipe.message);
                }
                else {
                    assertNull(outputPipe.message);
                }
            }
        }

        [Test(expects="Error")]
        public function testDynamicJunctionResetsAfterDisposal():void
        {
            var dynamicJunction:DynamicJunction = new DynamicJunction();
            dynamicJunction.dispose();

            dynamicJunction.retrievePipe("test_pipe");
        }
    }
}
