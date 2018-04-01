import maya.cmds as cmds
from PySide2 import QtCore
from PySide2 import QtGui
from PySide2 import QtWidgets
import maya.OpenMayaUI as omui

try:
    from shiboken import wrapInstance
except:
    from shiboken2 import wrapInstance


def getMayaWindow():
    pointer = omui.MQtUtil.mainWindow()
    if pointer is not None:
        return wrapInstance(long(pointer), QWidget)


def constraintMaster_UI():
    objectName = 'PyConstraintMasterWin'
    #check if ui already exists or not
    if cmds.window('PyConstraintMasterWin', exists=1):
        cmds.deleteUI('PyConstraintMasterWin',wnd=1)

    #create window
    parent = getMayaWindow()
    window = QtWidgets.QMainWindow(parent)
    window.setObjectName(objectName)
    window.setWindowTitle('Constraint Master')

    #create main widget
    mainWidget = QWidget()
    window.setCentralWidget(mainWidget)
    QtWidgets.QStyleFactory.create('Windows')
    #Create our main vertical layout
    verticalLayout = QtWidgets.QVBoxLayout(mainWidget)
    imagePath = cmds.internalVar(upd=1) + 'icons/wallpaper-cf1-1680x1050'
    window.setStyleSheet('background-image:url(' + imagePath + ');border:solid black 1px;')
    #create the translate layout
    translateLayout = QtWidgets.QHBoxLayout()
    verticalLayout.addLayout(translateLayout)

    #create translate label
    translateLabel = QtWidgets.QLabel('Translate:')
    translateLayout.addWidget(translateLabel)

    txCheckBox = QtWidgets.QCheckBox('X')
    translateLayout.addWidget(txCheckBox)

    tyCheckBox = QtWidgets.QCheckBox('Y')
    translateLayout.addWidget(tyCheckBox)

    tzCheckBox = QtWidgets.QCheckBox('Z')
    translateLayout.addWidget(tzCheckBox)


    #create the rotate layout
    rotateLayout = QtWidgets.QHBoxLayout()
    verticalLayout.addLayout(rotateLayout)

    #create the rotate layout
    scaleLayout = QtWidgets.QHBoxLayout()
    verticalLayout.addLayout(scaleLayout)

    #create button
    button = QtWidgets.QPushButton('Create Constraint')
    verticalLayout.addWidget(button)
    imagePath = cmds.internalVar(upd=1) + 'icons/2957c06bde98ccc.jpg'
    button.setStyleSheet('background-image:url(' + imagePath + ');border:solid black 1px;')



    #show the window
    window.show()

constraintMaster_UI()