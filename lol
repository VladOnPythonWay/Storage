import maya.cmds as cmds
from functools import partial

class AR_OptionsWindow(object):
    def showUI(cls):
        win = cls()
        win.create()
        return win
    def __init__(self):
        self.window = 'ar_optionsWindow'
        self.title = 'OptionsWindow'
        self.size = (1055,400)
        self.supportsToolAction = False
        self.actionName = 'Apply and Close'
        self.applyName = 'Apply'
        self.closeName = 'Close'
        
    def create(self):
        if cmds.window(self.window, exists= True):
            cmds.deleteUI(self.window ,window= True)
        self.window = cmds.window(self.window, title= self.title, widthHeight= self.size, s=True, menuBar= True)
        self.mainFormLayout = cmds.rowColumnLayout(numberOfColumns=6, cs=([1, 5],[2, 5],[3, 5],[4, 5],[5, 5], [6, 5]))
        self.ui_hairListCmd()
        self.ui_commonMenuCmd()
        self.ui_commonButtonsCmd()
        cmds.window(self.window, e=True, widthHeight= self.size)
        cmds.showWindow()
        
    def ui_commonMenuCmd(self):
        self.editMenu = cmds.menu(label= 'Edit')
        
        self.editMenuSave = cmds.menuItem(label= 'Save Settings', command= self.ui_editMenuSaveCmd)
        self.editMenuReset = cmds.menuItem(label= 'Reset Settings', command= self.ui_editMenuResetCmd)
        
        self.editMenuDiv = cmds.menuItem(d= True)
        self.editMenuRadio = cmds.radioMenuItemCollection()
        
        self.editMenuTool = cmds.menuItem(label= 'As Tool', radioButton= True, enable= self.supportsToolAction, command= self.ui_editMenuToolCmd)
        self.editMenuAction = cmds.menuItem(label= 'As Action', radioButton= True, enable= self.supportsToolAction, command= self.ui_editMenuActionCmd)
        
        self.helpMenu = cmds.menu('Help')
        self.helpMenuItem = cmds.menuItem(label= 'Help on {0}'.format(self.title), command= self.ui_helpMenuCmd)

    def ui_commonButtonsCmd(self):
        self.commonButtonsLayout = cmds.rowLayout(numberOfColumns=3, parent=self.checkBoxLayout)
        self.commonBtnSize = ((self.size[0]-18)/3, 26)
        self.actionBtn = cmds.button(label=self.actionName, height=self.commonBtnSize[1], width=self.commonBtnSize[0], command=self.ui_actionBtnCmd)
        self.applyBtn = cmds.button(label=self.applyName, height=self.commonBtnSize[1], width=self.commonBtnSize[0], command=self.ui_applyBtnCmd)
        self.closeBtn = cmds.button(label=self.closeName, height=self.commonBtnSize[1], width=self.commonBtnSize[0], command=self.ui_closeBtnCmd)
        cmds.rowLayout(self.commonButtonsLayout, e=True, adjustableColumn=2, columnAlign3=['left','center','right'], columnAttach=[(1, 'both', 0), (2, 'both', 0), (3, 'both', 0)])


    def ui_hairListCmd(self,*args):
        self.commonScrollListSize = self.size[1]/3
        self.hairFrontFrameLayoutA = cmds.frameLayout(label='               Front Hair', backgroundColor=[0.0, 0.0, 1.0], font='boldLabelFont', labelVisible=True, labelAlign='center', parent=self.mainFormLayout)
        self.hairFrontFrameLayoutB = cmds.frameLayout(label='             Load example:', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True, labelAlign='center')
        self.hairFrontFrameLayoutC = cmds.frameLayout(label='"hairFrontA_jtA_L/R", "*_jtB_*", ...', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True, labelAlign='left')

        self.hairFrontTabLayout = cmds.textScrollList(allowMultiSelection=True, height=self.commonScrollListSize, parent= self.hairFrontFrameLayoutC)

        self.hairFrontRowLayout = cmds.rowLayout(numberOfColumns=2, adjustableColumn=1, parent= self.hairFrontFrameLayoutC)
        self.hairFrontLoadButton = cmds.button(label='+', parent=self.hairFrontRowLayout, command= self.appendItemsCmd)
        self.hairFrontRemoveButton = cmds.button(label='-', parent=self.hairFrontRowLayout, command= self.removeItemsCmd)

        ######################################################################################################################################################################################################################

        self.hairSideFrameLayoutA = cmds.frameLayout(label='               Side Hair', backgroundColor=[0.0, 0.0, 1.0], font='boldLabelFont', labelVisible=True, parent=self.mainFormLayout)
        self.hairSideFrameLayoutB = cmds.frameLayout(label='             Load example:', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True)
        self.hairSideFrameLayoutC = cmds.frameLayout(label='"hairSideA_jtA_L/R", "*_jtB_*", ...', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True)

        self.hairSideTabLayout = cmds.textScrollList(allowMultiSelection=True, parent= self.hairSideFrameLayoutC)

        self.hairSideRowLayout = cmds.rowLayout(numberOfColumns=2, adjustableColumn=1, parent= self.hairSideFrameLayoutC)
        self.hairSideLoadButton = cmds.button(label='+', parent=self.hairSideRowLayout, command= self.appendItemsCmd)
        self.hairSideRemoveButton = cmds.button(label='-', parent=self.hairSideRowLayout, command= self.removeItemsCmd)

        ######################################################################################################################################################################################################################
        
        self.hairBackFrameLayoutA = cmds.frameLayout(label='               Back Hair', backgroundColor=[0.0, 0.0, 1.0], font='boldLabelFont', labelVisible=True, parent=self.mainFormLayout)
        self.hairBackFrameLayoutB = cmds.frameLayout(label='             Load example:', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True)
        self.hairBackFrameLayoutC = cmds.frameLayout(label='"hairBackA_jtA_L/R", "*_jtB_*", ...', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True)

        self.hairBackTabLayout = cmds.textScrollList(allowMultiSelection=True, parent= self.hairBackFrameLayoutC)

        self.hairBackRowLayout = cmds.rowLayout(numberOfColumns=2, adjustableColumn=1, parent= self.hairBackFrameLayoutC)
        self.hairBackLoadButton = cmds.button(label='+', parent=self.hairBackRowLayout, command= self.appendItemsCmd)
        self.hairBackRemoveButton = cmds.button(label='-', parent=self.hairBackRowLayout, command= self.removeItemsCmd)

        ######################################################################################################################################################################################################################
        
        self.hairNeckFrameLayoutA = cmds.frameLayout(label='               Neck Hair', backgroundColor=[0.0, 0.0, 1.0], font='boldLabelFont', labelVisible=True, parent=self.mainFormLayout)
        self.hairNeckFrameLayoutB = cmds.frameLayout(label='             Load example:', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True)
        self.hairNeckFrameLayoutC = cmds.frameLayout(label='"hairNeckA_jtA_L/R", "*_jtB_*", ...', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True)

        self.hairNeckTabLayout = cmds.textScrollList(allowMultiSelection=True, parent= self.hairNeckFrameLayoutC)

        self.hairNeckRowLayout = cmds.rowLayout(numberOfColumns=2, adjustableColumn=1, parent= self.hairNeckFrameLayoutC)
        self.hairNeckLoadButton = cmds.button(label='+', parent=self.hairNeckRowLayout, command= self.appendItemsCmd)
        self.hairNeckRemoveButton = cmds.button(label='-', parent=self.hairNeckRowLayout, command= self.removeItemsCmd)

        ######################################################################################################################################################################################################################
        
        self.hairTopFrameLayoutA = cmds.frameLayout(label='               Top Hair', backgroundColor=[0.0, 0.0, 1.0], font='boldLabelFont', labelVisible=True, parent=self.mainFormLayout)
        self.hairTopFrameLayoutB = cmds.frameLayout(label='             Load example:', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True)
        self.hairTopFrameLayoutC = cmds.frameLayout(label='"hairTopA_jtA_L/R", "*_jtB_*", ...', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True)

        self.hairTopTabLayout = cmds.textScrollList(allowMultiSelection=True, parent= self.hairTopFrameLayoutC)

        self.hairTopRowLayout = cmds.rowLayout(numberOfColumns=2, adjustableColumn=1, parent= self.hairTopFrameLayoutC)
        self.hairTopLoadButton = cmds.button(label='+', parent=self.hairTopRowLayout, command= self.appendItemsCmd)
        self.hairTopRemoveButton = cmds.button(label='-', parent=self.hairTopRowLayout, command= self.removeItemsCmd)

        ######################################################################################################################################################################################################################
        
        self.hairExtraFrameLayoutA = cmds.frameLayout(label='               Extra Hair', backgroundColor=[0.0, 0.0, 1.0], font='boldLabelFont', labelVisible=True, parent=self.mainFormLayout)
        self.hairExtraFrameLayoutB = cmds.frameLayout(label='             Load example:', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True)
        self.hairExtraFrameLayoutC = cmds.frameLayout(label='"hairExtraA_jtA_L/R", "*_jtB_*", ...', backgroundColor=[0.5, 0.5, 0.5], font='smallBoldLabelFont', labelVisible=True)

        self.hairExtraTabLayout = cmds.textScrollList(allowMultiSelection=True, parent= self.hairExtraFrameLayoutC)
        
        self.hairExtraRowLayout = cmds.rowLayout(numberOfColumns=2, adjustableColumn=True, parent= self.hairExtraFrameLayoutC)
        self.hairExtraLoadButton = cmds.button(label='+', parent=self.hairExtraRowLayout, command= self.appendItemsCmd)
        self.hairExtraRemoveButton = cmds.button(label='-', parent=self.hairExtraRowLayout, command= self.removeItemsCmd)
        ######################################################################################################################################################################################################################
        

        self.checkBoxLayout = cmds.rowColumnLayout(nr=4, adj=True, rs=([1, 5],[2, 5],[3, 5],[4,40]), p=self.window)
        self.passiveHairLayout = cmds.rowLayout(nc=7, adj=7, p=self.checkBoxLayout)
        self.passiveJointCheckBox = cmds.checkBox(label='Passive Joint Chain:                             ', parent=self.passiveHairLayout)
        self.passiveFrontHairCheckBox = cmds.checkBox(label='Front Hair', enable=False, parent=self.passiveHairLayout)
        self.passiveSideHairCheckBox = cmds.checkBox(label='Side Hair', enable=False, parent=self.passiveHairLayout)
        self.passiveBackHairCheckBox = cmds.checkBox(label='Back Hair', enable=False, parent=self.passiveHairLayout)
        self.passiveNeckHairCheckBox = cmds.checkBox(label='Neck Hair', enable=False, parent=self.passiveHairLayout)
        self.passiveTopHairCheckBox = cmds.checkBox(label='Top Hair', enable=False, parent=self.passiveHairLayout)
        self.passiveExtraHairCheckBox = cmds.checkBox(label='Extra Hair', enable=False, parent=self.passiveHairLayout)
        
        self.drivenHairLayout = cmds.rowLayout(nc=7, adj=7, p=self.checkBoxLayout)
        self.drivenJointCheckBox = cmds.checkBox(label='Driven Key Joint Chain:                       ',enable=False, parent=self.drivenHairLayout)
        self.drivenFrontHairCheckBox = cmds.checkBox(label='Front Hair', enable=False, parent=self.drivenHairLayout)
        self.drivenSideHairCheckBox = cmds.checkBox(label='Side Hair', enable=False, parent=self.drivenHairLayout)
        self.drivenBackHairCheckBox = cmds.checkBox(label='Back Hair', enable=False, parent=self.drivenHairLayout)
        self.drivenNeckHairCheckBox = cmds.checkBox(label='Neck Hair', enable=False, parent=self.drivenHairLayout)
        self.drivenTopHairCheckBox = cmds.checkBox(label='Top Hair', enable=False, parent=self.drivenHairLayout)
        self.drivenExtraHairCheckBox = cmds.checkBox(label='Extra Hair', enable=False, parent=self.drivenHairLayout)
        
        self.ikHairLayout = cmds.rowLayout(nc=7, adj=7, p=self.checkBoxLayout)
        self.ikJointCheckBox = cmds.checkBox(label='IK Joint Chain:                                      ', enable=False, parent=self.ikHairLayout)
        self.ikFrontHairCheckBox = cmds.checkBox(label='Front Hair', enable=False, parent=self.ikHairLayout)
        self.ikSideHairCheckBox = cmds.checkBox(label='Side Hair', enable=False, parent=self.ikHairLayout)
        self.ikBackHairCheckBox = cmds.checkBox(label='Back Hair', enable=False, parent=self.ikHairLayout)
        self.ikNeckHairCheckBox = cmds.checkBox(label='Neck Hair', enable=False, parent=self.ikHairLayout)
        self.ikTopHairCheckBox = cmds.checkBox(label='Top Hair', enable=False, parent=self.ikHairLayout)
        self.ikExtraHairCheckBox = cmds.checkBox(label='Extra Hair', enable=False, parent=self.ikHairLayout)


    
    def ui_enablePassiveJointChain(self,*args):
        pass
        """
        cmds.checkBox(self.drivenJointCheckBox, e=True, enable=True)
        cmds.checkBox(self.ikJointCheckBox, e=True, enable=True)
        
        cmds.checkBox(self.passiveFrontHairCheckBox, e=True, enable=True)
        cmds.checkBox(self.passiveSideHairCheckBox, e=True, enable=True)
        cmds.checkBox(self.passiveBackHairCheckBox, e=True, enable=True)
        cmds.checkBox(self.passiveNeckHairCheckBox, e=True, enable=True)
        cmds.checkBox(self.passiveTopHairCheckBox, e=True, enable=True)
        cmds.checkBox(self.passiveExtraHairCheckBox, e=True, enable=True)
        """
        
    def ui_disablePassiveJointChain(self,*args):
        pass
        """
        cmds.checkBox(self.drivenJointCheckBox, e=True, enable=False)
        cmds.checkBox(self.ikJointCheckBox, e=True, enable=False)
        
        cmds.checkBox(self.passiveFrontHairCheckBox, e=True, enable=False)
        cmds.checkBox(self.passiveSideHairCheckBox, e=True, enable=False)
        cmds.checkBox(self.passiveBackHairCheckBox, e=True, enable=False)
        cmds.checkBox(self.passiveNeckHairCheckBox, e=True, enable=False)
        cmds.checkBox(self.passiveTopHairCheckBox, e=True, enable=False)
        cmds.checkBox(self.passiveExtraHairCheckBox, e=True, enable=False)
        """

    def ui_helpMenuCmd(self, *args):
        cmds.launch(web= 'http://google.com')
        
    def ui_editMenuSaveCmd(self, *args):
        pass
    
    def ui_editMenuResetCmd(self, *args):
        pass
        
    def ui_editMenuToolCmd(self, *args):
        pass
    
    def ui_editMenuActionCmd(self, *args):
        pass
        
    def ui_actionBtnCmd(self,*args):
        self.ui_applyBtnCmd()
        self.ui_closeBtnCmd()
    
    def ui_applyBtnCmd(self, *args):
        pass
        
    def ui_closeBtnCmd(self, *args):
        cmds.deleteUI(self.window, window=True)

    def appendItemsCmd(self,*args):
        pass

    def removeItemsCmd(self,*args):
        pass

    def ui_hairCheckCmd(self,*args):
        pass
        #self.hairFrontCheckBox = cmds.checkBox(label='Front')

test = AR_OptionsWindow()
test.create()













