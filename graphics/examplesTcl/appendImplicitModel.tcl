# this demonstrates appending data to generate an implicit model

catch {load vtktcl}
source vtkInt.tcl

vtkLineSource lineX
    lineX SetPoint1 -2.0 0.0 0.0
    lineX SetPoint2  2.0 0.0 0.0
    lineX Update
vtkLineSource lineY
    lineY SetPoint1  0.0 -2.0 0.0
    lineY SetPoint2  0.0  2.0 0.0
    lineY Update
vtkLineSource lineZ
    lineZ SetPoint1 0.0 0.0 -2.0
    lineZ SetPoint2 0.0 0.0  2.0
    lineZ Update
vtkPlaneSource aPlane
    aPlane Update

set Data(0) "lineX"
set Data(1) "lineY"
set Data(2) "lineZ"
set Data(3) "aPlane"

vtkImplicitModeller imp
    imp SetModelBounds -2.5 2.5 -2.5 2.5 -2.5 2.5
    imp SetSampleDimensions 100 100 100
    imp DebugOn

# Okay now let's see if we can append
imp StartAppend
for {set i 0} {$i < 4} {incr i} {
    imp Append [$Data($i) GetOutput]
}
imp EndAppend


vtkContourFilter cf
cf SetInput [imp GetOutput]
    cf SetValue 0 0.1
vtkPolyDataMapper mapper
    mapper SetInput [cf GetOutput]
vtkActor actor
    actor SetMapper mapper

vtkOutlineFilter outline
    outline SetInput [imp GetOutput]
vtkPolyDataMapper outlineMapper
    outlineMapper SetInput [outline GetOutput]
vtkActor outlineActor
    outlineActor SetMapper outlineMapper

vtkStructuredPointsGeometryFilter plane
    plane SetInput [imp GetOutput]
    plane SetExtent 0 100 0 100 50 50
vtkPolyDataMapper planeMapper
    planeMapper SetInput [plane GetOutput]
    planeMapper SetScalarRange 0.197813 0.710419
vtkActor planeActor
    planeActor SetMapper planeMapper

# graphics stuff
vtkRenderer ren
    ren AddActor actor
    ren AddActor planeActor
    ren AddActor outlineActor
vtkRenderWindow renWin
    renWin AddRenderer ren
vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin

ren SetBackground 0.1 0.2 0.4
iren SetUserMethod {wm deiconify .vtkInteract}
iren Initialize

wm withdraw .
