import sys
import time
sys.path.append('/home/wmendiza/research/blender/brokap')

import bpy
from bgl import *
from mathutils import Matrix

try:
    kinect.poll()
except:
    from brokap import Kinect
    kinect = Kinect()

calibration = {}

def draw_callback(self, context):
    
    data = kinect.get_data()
    width = kinect.get_width()
    height = kinect.get_height()
    
    buf = Buffer(GL_FLOAT, len(data), data)
    
    texture = Buffer(GL_INT, 1)
    
    glEnable(GL_TEXTURE_2D)
    
    glGenTextures(1, texture)
        
    glBindTexture(GL_TEXTURE_2D, texture[0])    
        
    glTexImage2D(GL_TEXTURE_2D, 0, 1, width, height, 0, GL_RGB, GL_FLOAT, buf)
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    
    glEnable(GL_BLEND)
    glDisable(GL_DEPTH_TEST)
    
    #glBlendFunc(GL_DST_COLOR, GL_ZERO)
    glBindTexture(GL_TEXTURE_2D, texture[0])
    glColor4f(1.0, 1.0, 1.0, 1.0)
    glLineWidth(10)
        

    glBegin(GL_QUADS)
    
    glTexCoord2f(0,1)
    glVertex2i(0,0)
    
    glTexCoord2f(0,0)
    glVertex2i(0,100)
    
    glTexCoord2f(1,0)
    glVertex2i(100,100)
    
    glTexCoord2f(1,1)    
    glVertex2i(100,0)

    glEnd()
    
    glDeleteTextures(1, texture)
    glLineWidth(1)
    glDisable(GL_BLEND)
    glEnable(GL_DEPTH_TEST)
    glColor4f(0.0, 0.0, 0.0, 1.0)

class BrokapUI(bpy.types.Panel):
    bl_label = " "
    bl_idname = "brokapui"
    bl_space_type = "PROPERTIES"
    bl_region_type = "WINDOW"
    bl_context = "object"

    def __init__(self):
        super(BrokapUI, self).__init__()

    def draw_header(self, context):
        layout = self.layout
        layout.label(text="Brokap panel", icon="ARMATURE_DATA")

    def draw(self, context):
        layout = self.layout

        obj = context.object

        row = layout.row()
        row.label(text="Active object is: " + obj.name)
        
        row = layout.row()
        split = row.split(percentage=0.5)
        
        colL = split.column()
        colR = split.column()
        
        colL.operator('brokapui.record', text='record', icon='PLAY') #PAUSE
        colR.operator('brokapui.stop', text='stop', icon='PAUSE')

class BrokapUI_calibrate(bpy.types.Operator):
    bl_label = "Brokap calibrate"
    bl_idname = 'brokapui.calibrate'
    bl_description = 'Calibrate kinect movements'
    
    _timer = None
    
    def __init__(self):
        pass
    
    def __del__(self):
        pass
        
    def modal(self, context, event):
        context.area.tag_redraw()
        
        if time.time() - self._start > 10:
            context.window_manager.event_timer_remove(self._timer)
            try:
                context.region.callback_remove(self._handle)
            except:
                pass

            torso = bpy.data.objects['torso'].location
            left_foot = bpy.data.objects['left_foot'].location
            calibration['x'] = torso[0]
            calibration['y'] = torso[1]
            calibration['z'] = left_foot[2]

            for item in kinect.ITEMS:
                bpy.data.objects[item].location[0] -= calibration['x']
                bpy.data.objects[item].location[1] -= calibration['y']
                bpy.data.objects[item].location[2] -= calibration['z']

        elif event.type == 'ESC':
            context.window_manager.event_timer_remove(self._timer)
            context.region.callback_remove(self._handle)
            return {'CANCELLED'}
        elif event.type == 'TIMER':
            print(context.object.name)
            kinect.poll()

            for item in kinect.ITEMS:
                bpy.data.objects[item].location = kinect.get_position(item)
            
        return {'PASS_THROUGH'}
    
    def execute(self, context):
        self._start = time.time()

        context.window_manager.modal_handler_add(self)
        self._handle = context.region.callback_add(draw_callback, (self, context), 'POST_PIXEL')
        self.report('INFO', 'start recording')
        self._timer = context.window_manager.event_timer_add(0.1, context.window)        
        return {'RUNNING_MODAL'}



class BrokapUI_record(bpy.types.Operator):
    bl_label = "Brokap record"
    bl_idname = 'brokapui.record'
    bl_description = 'Record kinect movements'
    
    _timer = None
    
    def __init__(self):
        pass
    
    def __del__(self):
        pass
        
    def modal(self, context, event):
        context.area.tag_redraw()
        
        if not bpy.types.brokapui.active:
            context.window_manager.event_timer_remove(self._timer)
            context.region.callback_remove(self._handle)
            return {'FINISHED'}
        elif event.type == 'ESC':
            context.window_manager.event_timer_remove(self._timer)
            context.region.callback_remove(self._handle)
            return {'CANCELLED'}
        elif event.type == 'TIMER':
            print(context.object.name)
            kinect.poll()

            for item in kinect.ITEMS:
                bpy.data.objects[item].location = kinect.get_position(item)
                bpy.data.objects[item].location[0] -= calibration['x']
                bpy.data.objects[item].location[1] -= calibration['y']
                bpy.data.objects[item].location[2] -= calibration['z']

                #bpy.data.objects[item].rotation_quaternion = Matrix(kinect.get_rotation(item)).to_quaternion()
            
            #context.object.location = kinect.get_position('torso')
            #context.object.rotation_quaternion = Matrix(kinect.get_rotation('torso')).to_quaternion()

            #draw_callback(self, context)
            
        return {'PASS_THROUGH'}
    
    def execute(self, context):
        bpy.types.brokapui.active = True

        context.window_manager.modal_handler_add(self)
        self._handle = context.region.callback_add(draw_callback, (self, context), 'POST_PIXEL')
        self.report('INFO', 'start recording')
        self._timer = context.window_manager.event_timer_add(0.1, context.window)        
        return {'RUNNING_MODAL'}


class BrokapUI_stop(bpy.types.Operator):
    bl_label = "Brokap stop"
    bl_idname = 'brokapui.stop'
    bl_description = 'Stop recording'
    
    def invoke(self, context, event):
        self.report('INFO', 'stop recording')
        bpy.types.brokapui.active = False
        return {'FINISHED'}

def register():
    bpy.utils.register_class(BrokapUI)
    bpy.utils.register_class(BrokapUI_calibrate)
    bpy.utils.register_class(BrokapUI_record)
    bpy.utils.register_class(BrokapUI_stop)


def unregister():
    bpy.utils.unregister_class(BrokapUI)
    bpy.utils.unregister_class(BrokapUI_calibrate)
    bpy.utils.unregister_class(BrokapUI_record)
    bpy.utils.unregister_class(BrokapUI_stop)


if __name__ == "__main__":
    register()
