# Perfusion MRI Gradient Tractography in Acute Stroke

<img src="http://mri-q.com/uploads/3/4/5/7/34572113/7546639_orig.gif?259" alt="img" width="200">

## 1.file list:

###[classification.m](https://github.com/MarcWong/PTI/blob/master/classification.m)

**Classify the pics by its z coordinate, and build the voxel**

*根据z坐标对图片进行分类 生成voxel*

###[bgSignal.m](https://github.com/MarcWong/PTI/blob/master/bgSignal.m)

**Computaion the baseline signal intensity s0 for each layer**

*计算背景信号强度s0*


###[concentration.m](https://github.com/MarcWong/PTI/blob/master/concentration.m)

**Computaion of Concentration**

*计算浓度函数c*

###[CVoxelBuild.m](https://github.com/MarcWong/PTI/blob/master/CVoxelBuild.m)

**Turn raw data of concentration to concentration of each voxel, using linear interpolation**

*将初始浓度数据转化为每个体素的浓度，使用线性差值方法*

###[gradientVisualization.m](https://github.com/MarcWong/PTI/blob/master/gradientVisualization.m)

**Gaussian filter, Computaion of tensor, convert the gradient data to RGB image, visualization**

*高斯平滑、可视化显示*


###[rec2sphere.m](https://github.com/MarcWong/PTI/blob/master/rec2sphere.m)

**transvert Cartesian coordinate to spherical coordinate**

*直角坐标转球坐标*

###[tensorGeneration.m](https://github.com/MarcWong/PTI/blob/master/tensorGeneration.m)

**display gradient field on a 2d image**

*表示梯度场*

###[PlotEllipse.m](https://github.com/MarcWong/PTI/blob/master/PlotEllipse.m)

**plot ellipse(represent for tensor)**

*画椭圆表示梯度强度*


## 2.Project Introduction
[paper editing](https://www.overleaf.com/5853697wdvqfy#/19294796/)
## 3.Author
[Yao Wang](https://www.facebook.com/marcSwong) at Peking University & UCLA


