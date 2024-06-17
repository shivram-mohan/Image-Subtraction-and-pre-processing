classdef image_sub < matlab.apps.AppBase
 % Properties that correspond to app components
 properties (Access = public)
 UIFigure matlab.ui.Figure
 GridLayout matlab.ui.container.GridLayout
 LeftPanel matlab.ui.container.Panel
 EXPORTButton matlab.ui.control.Button
 CONTRASTKnob matlab.ui.control.Knob
 CONTRASTKnobLabel matlab.ui.control.Label
 BRIGHTNESSKnob matlab.ui.control.Knob
 BRIGHTNESSKnobLabel matlab.ui.control.Label
 RightPanel matlab.ui.container.Panel
 GridLayout2 matlab.ui.container.GridLayout
 StandardDeviationforGaussianFilterSlider matlab.ui.control.Slider
 StandardDeviationforGaussianFilterSliderLabel matlab.ui.control.Label
 EditField matlab.ui.control.EditField
 SubtractButton matlab.ui.control.Button
 UploadtheImagesButton matlab.ui.control.Button
 UIAxes_3 matlab.ui.control.UIAxes
 end
 % Properties that correspond to apps with auto-reflow
 properties (Access = private)
 onePanelWidth = 576;
 end
 
 properties (Access = private)
 img1;
 img2;
 img3;% Description
 imgfilter;
 imgbright;
 imgcontr;
 final;
 brightness=0;
 contrast=0;
 end
 
 % Callbacks that handle component events
 methods (Access = private)
 % Button pushed function: UploadtheImagesButton
 function UploadtheImagesButtonPushed(app, event)
 [fileName1, filePath1] = uigetfile({'*.jpg;*.jpeg;*.png', 'Image Files 
(*.jpg, *.jpeg, *.png)'}, 'Select an image file');
 fullFilePath1 = fullfile(filePath1, fileName1);
 imageData1 = imread(fullFilePath1);
 app.img1=imageData1;
 % Display the image on the UI axis
 [fileName2, filePath2] = uigetfile({'*.jpg;*.jpeg;*.png', 'Image Files 
(*.jpg, *.jpeg, *.png)'}, 'Select an image file');
 if fileName2 == 0
 return;
 end
 fullFilePath2 = fullfile(filePath2, fileName2);
 imageData2 = imread(fullFilePath2);
 app.img2=imageData2;
 % Display the image on the UI axis
 
 end
 % Button pushed function: SubtractButton
 function SubtractButtonPushed(app, event)
 desiredSize = [size(app.img1, 1), size(app.img1, 2)]; % Specify 
desired size
 image1_resized = imresize(app.img1, desiredSize);
 image2_resized = imresize(app.img2, desiredSize);
 % Convert the images to double precision for accurate subtraction
 image1_double = im2double(image1_resized);
 image2_double = im2double(image2_resized);
 sub = imsubtract(image1_double, image2_double);
 imshow(sub, 'Parent', app.UIAxes_3);
 app.img3=sub;
 end
 % Value changing function: StandardDeviationforGaussianFilterSlider
 function StandardDeviationforGaussianFilterSliderValueChanging(app, event)
 changingValue = event.Value;
 filter = imgaussfilt((app.img3), changingValue);
 imshow(filter, 'Parent', app.UIAxes_3);
 app.imgfilter=filter;
 end
 % Value changing function: BRIGHTNESSKnob
 function BRIGHTNESSKnobValueChanging(app, event)
 brightness_offset = event.Value;
 app.brightness=brightness_offset;
 if (app.contrast)==0
 originalImage=app.imgfilter;
 % Read the image
 originalImage = im2double(originalImage);
 brightenedImage = originalImage + brightness_offset;
 % Clip the values to ensure they remain in the valid range [0, 1]
 brightenedImage = max(0, min(brightenedImage, 1));
 imshow(brightenedImage, 'Parent', app.UIAxes_3);
 app.imgbright=brightenedImage;
 app.final=brightenedImage;
 else
 originalImage=app.imgcontr;
 % Read the image
 originalImage = im2double(originalImage);
 brightenedImage = originalImage + brightness_offset;
 % Clip the values to ensure they remain in the valid range [0, 1]
 brightenedImage = max(0, min(brightenedImage, 1));
 imshow(brightenedImage, 'Parent', app.UIAxes_3);
 app.imgbright=brightenedImage;
 app.final=brightenedImage;
 end
 
 end
 % Value changing function: CONTRASTKnob
 function CONTRASTKnobValueChanging(app, event)
 changingValue = event.Value;
 app.contrast=changingValue;
 if (app.brightness)==0
 originalImage=app.imgfilter;
 else
 originalImage=app.imgbright;
 end
 originalImage = im2double(originalImage);
 % Adjust contrast by multiplying with contrastFactor
 adjustedImage = originalImage * changingValue;
 % Clip the values to ensure they remain in the valid range [0, 1]
 adjustedImage = max(0, min(adjustedImage, 1));
 imshow(adjustedImage, 'Parent', app.UIAxes_3);
 app.imgcontr=adjustedImage;
 end
 % Button pushed function: EXPORTButton
 function EXPORTButtonPushed(app, event)
 outputPath = 'C:\Users\achuj\Documents\_IMG_SUB\exported_image.jpg'; % 
Change the path and filename as needed
 imwrite((app.final), outputPath);
 end
 % Changes arrangement of the app based on UIFigure width
 function updateAppLayout(app, event)
 currentFigureWidth = app.UIFigure.Position(3);
 if(currentFigureWidth <= app.onePanelWidth)
 % Change to a 2x1 grid
 app.GridLayout.RowHeight = {472, 472};
 app.GridLayout.ColumnWidth = {'1x'};
 app.RightPanel.Layout.Row = 2;
 app.RightPanel.Layout.Column = 1;
 else
 % Change to a 1x2 grid
 app.GridLayout.RowHeight = {'1x'};
 app.GridLayout.ColumnWidth = {164, '1x'};
 app.RightPanel.Layout.Row = 1;
 app.RightPanel.Layout.Column = 2;
 end
 end
 end
 % Component initialization
 methods (Access = private)
 % Create UIFigure and components
 function createComponents(app)
 % Create UIFigure and hide until all components are created
 app.UIFigure = uifigure('Visible', 'off');
 app.UIFigure.AutoResizeChildren = 'off';
 app.UIFigure.Position = [100 100 693 472];
 app.UIFigure.Name = 'MATLAB App';
 app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, 
true);
 % Create GridLayout
 app.GridLayout = uigridlayout(app.UIFigure);
 app.GridLayout.ColumnWidth = {164, '1x'};
 app.GridLayout.RowHeight = {'1x'};
 app.GridLayout.ColumnSpacing = 0;
 app.GridLayout.RowSpacing = 0;
 app.GridLayout.Padding = [0 0 0 0];
 app.GridLayout.Scrollable = 'on';
 % Create LeftPanel
 app.LeftPanel = uipanel(app.GridLayout);
 app.LeftPanel.BorderWidth = 3;
 app.LeftPanel.Layout.Row = 1;
 app.LeftPanel.Layout.Column = 1;
 % Create BRIGHTNESSKnobLabel
 app.BRIGHTNESSKnobLabel = uilabel(app.LeftPanel);
 app.BRIGHTNESSKnobLabel.HorizontalAlignment = 'center';
 app.BRIGHTNESSKnobLabel.FontSize = 14;
 app.BRIGHTNESSKnobLabel.FontWeight = 'bold';
 app.BRIGHTNESSKnobLabel.Position = [46 287 97 22];
 app.BRIGHTNESSKnobLabel.Text = 'BRIGHTNESS';
 % Create BRIGHTNESSKnob
 app.BRIGHTNESSKnob = uiknob(app.LeftPanel, 'continuous');
 app.BRIGHTNESSKnob.Limits = [-0.75 0.75];
 app.BRIGHTNESSKnob.ValueChangingFcn = createCallbackFcn(app, 
@BRIGHTNESSKnobValueChanging, true);
 app.BRIGHTNESSKnob.FontWeight = 'bold';
 app.BRIGHTNESSKnob.Position = [62 343 60 60];
 % Create CONTRASTKnobLabel
 app.CONTRASTKnobLabel = uilabel(app.LeftPanel);
 app.CONTRASTKnobLabel.HorizontalAlignment = 'center';
 app.CONTRASTKnobLabel.FontSize = 14;
 app.CONTRASTKnobLabel.FontWeight = 'bold';
 app.CONTRASTKnobLabel.Position = [38 117 83 22];
 app.CONTRASTKnobLabel.Text = 'CONTRAST';
 % Create CONTRASTKnob
 app.CONTRASTKnob = uiknob(app.LeftPanel, 'continuous');
 app.CONTRASTKnob.Limits = [0.25 2];
 app.CONTRASTKnob.ValueChangingFcn = createCallbackFcn(app, 
@CONTRASTKnobValueChanging, true);
 app.CONTRASTKnob.FontWeight = 'bold';
 app.CONTRASTKnob.Position = [49 169 60 60];
 app.CONTRASTKnob.Value = 1;
 % Create EXPORTButton
 app.EXPORTButton = uibutton(app.LeftPanel, 'push');
 app.EXPORTButton.ButtonPushedFcn = createCallbackFcn(app, 
@EXPORTButtonPushed, true);
 app.EXPORTButton.Position = [30 38 100 23];
 app.EXPORTButton.Text = 'EXPORT';
 % Create RightPanel
 app.RightPanel = uipanel(app.GridLayout);
 app.RightPanel.Layout.Row = 1;
 app.RightPanel.Layout.Column = 2;
 % Create GridLayout2
 app.GridLayout2 = uigridlayout(app.RightPanel);
 app.GridLayout2.ColumnWidth = {'1.86x', '1x', 117};
 app.GridLayout2.RowHeight = {'8.85x', '3.8x', 23, 20, '1x', 23};
 app.GridLayout2.RowSpacing = 7.30000577654157;
 app.GridLayout2.Padding = [10 7.30000577654157 10 7.30000577654157];
 % Create UIAxes_3
 app.UIAxes_3 = uiaxes(app.GridLayout2);
 title(app.UIAxes_3, 'Output')
 xlabel(app.UIAxes_3, 'X')
 ylabel(app.UIAxes_3, 'Y')
 zlabel(app.UIAxes_3, 'Z')
 app.UIAxes_3.Layout.Row = [1 2];
 app.UIAxes_3.Layout.Column = [1 3];
 % Create UploadtheImagesButton
 app.UploadtheImagesButton = uibutton(app.GridLayout2, 'push');
 app.UploadtheImagesButton.ButtonPushedFcn = createCallbackFcn(app, 
@UploadtheImagesButtonPushed, true);
 app.UploadtheImagesButton.IconAlignment = 'bottom';
 app.UploadtheImagesButton.VerticalAlignment = 'top';
 app.UploadtheImagesButton.FontSize = 14;
 app.UploadtheImagesButton.Layout.Row = 3;
 app.UploadtheImagesButton.Layout.Column = 2;
 app.UploadtheImagesButton.Text = 'Upload the Images';
 % Create SubtractButton
 app.SubtractButton = uibutton(app.GridLayout2, 'push');
 app.SubtractButton.ButtonPushedFcn = createCallbackFcn(app, 
@SubtractButtonPushed, true);
 app.SubtractButton.IconAlignment = 'bottom';
 app.SubtractButton.VerticalAlignment = 'top';
 app.SubtractButton.FontSize = 14;
 app.SubtractButton.FontWeight = 'bold';
 app.SubtractButton.Layout.Row = 3;
 app.SubtractButton.Layout.Column = 3;
 app.SubtractButton.Text = 'Subtract';
 % Create EditField
 app.EditField = uieditfield(app.GridLayout2, 'text');
 app.EditField.HorizontalAlignment = 'center';
 app.EditField.FontName = 'Forte';
 app.EditField.FontSize = 30;
 app.EditField.FontColor = [1 1 1];
 app.EditField.BackgroundColor = [0 0 0];
 app.EditField.Layout.Row = [3 6];
 app.EditField.Layout.Column = 1;
 app.EditField.Value = 'Image Subtractor';
 % Create StandardDeviationforGaussianFilterSliderLabel
 app.StandardDeviationforGaussianFilterSliderLabel = 
uilabel(app.GridLayout2);
 app.StandardDeviationforGaussianFilterSliderLabel.HorizontalAlignment 
= 'right';
 app.StandardDeviationforGaussianFilterSliderLabel.FontSize = 14;
 app.StandardDeviationforGaussianFilterSliderLabel.Layout.Row = 4;
 app.StandardDeviationforGaussianFilterSliderLabel.Layout.Column = [2 
3];
 app.StandardDeviationforGaussianFilterSliderLabel.Text = 'Standard 
Deviation for Gaussian Filter';
 % Create StandardDeviationforGaussianFilterSlider
 app.StandardDeviationforGaussianFilterSlider = 
uislider(app.GridLayout2);
 app.StandardDeviationforGaussianFilterSlider.Limits = [0 5];
 app.StandardDeviationforGaussianFilterSlider.ValueChangingFcn = 
createCallbackFcn(app, @StandardDeviationforGaussianFilterSliderValueChanging, 
true);
 app.StandardDeviationforGaussianFilterSlider.Layout.Row = 5;
 app.StandardDeviationforGaussianFilterSlider.Layout.Column = [2 3];
 % Show the figure after all components are created
 app.UIFigure.Visible = 'on';
 end
 end
 % App creation and deletion
 methods (Access = public)
 % Construct app
 function app = image_sub
 % Create UIFigure and components
 createComponents(app)
 % Register the app with App Designer
 registerApp(app, app.UIFigure)
 if nargout == 0
 clear app
 end
 end
 % Code that executes before app deletion
 function delete(app)
 % Delete UIFigure when app is deleted
 delete(app.UIFigure)
 end
 end
end