import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/features/courses/data/models/category_response_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';
import 'package:learning_management_system/features/courses/data/models/create_course_request_model.dart';
import 'package:learning_management_system/features/courses/data/models/topic_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_cousre_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_state.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_cubit.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_state.dart';
import 'package:learning_management_system/features/teacher/is_changed_cubit.dart';


// ignore: must_be_immutable
class CreateCourseScreen extends StatefulWidget {
  String? status;
  final int? courseId;
  final bool ?isCopy;

   CreateCourseScreen({super.key, this.status, required this.courseId,this.isCopy});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  CourseDetailsModel? course;


  String? _initialTopicTitle;
  String? _initialCategoryTitle;
  String? _initialLanguage;
  File? _courseImage;
  String? _existingImageUrl; 
  String? _selectedLevel;
  bool _hasCertificate = true;
  CountryOrLanguageSubModel? _selectedLanguage;
  int? _courseId; 
  int? numberOfStudent; 
  String _status = 'draft'; // Local status state



  @override
  void initState() {
    super.initState();
        WidgetsBinding.instance.addObserver(this);

    _status = widget.status ?? 'draft';
    if (widget.courseId != null)
      context.read<ShowCourseCubit>().showCourseForTeacher(widget.courseId!,widget.isCopy!);
  }



    @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && (isChanged()|| context.read<IsChangedCubit>().isChanged )) {
      _showExitConfirmation();
    }
  }

  Future<bool> _onWillPop() async {
    if (isChanged()) {
      return await _showExitConfirmation() ?? false;
    }
    return true;
  }

  Future<bool?> _showExitConfirmation() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Unsaved Changes'),
        content: Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Discard'),
          ),
        ],
      ),
    );
  }


  void _initializeForm() {
    if (course != null) {
      _courseId = course!.id;
      _titleController.text = course!.title;
      _descriptionController.text = course!.description;
      _priceController.text = course!.price.toString();
      _selectedLevel = course!.difficultyLevel;
      _existingImageUrl = course!.imageUrl;
      _hasCertificate = course!.hasCertificate;
      _status = widget.status!; 
      _initialTopicTitle = course!.topic;
      _initialLanguage = course!.language;
      _initialCategoryTitle = course!.category;
      numberOfStudent = course!.numOfStudentsEnrolled;
      
    }
  }
  bool isChanged(){
    if(course != null)
    return _courseId != course!.id||
      _titleController.text != course!.title||
      _descriptionController.text != course!.description||
      _priceController.text != course!.price.toString()||
      _selectedLevel != course!.difficultyLevel||
      _existingImageUrl != course!.imageUrl||
      _hasCertificate != course!.hasCertificate||
      _initialTopicTitle != course!.topic||
      _initialLanguage != course!.language||
      _initialCategoryTitle != course!.category;

      return false;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _courseImage = File(pickedFile.path);
        _existingImageUrl = null; 
      });
    }
  }

  void _submitForm() {
    print(widget.status);
    if (_formKey.currentState!.validate() &&
        (_courseImage != null || _existingImageUrl != null) &&
        _selectedLevel != null &&
        _selectedLanguage != null) {
      final requestModel = CreateCourseRequestModel(
        topicId: context.read<TopicCubit>().selectedTopic!.id,
        languageId: _selectedLanguage!.id,
        title: _titleController.text,
        description: _descriptionController.text,
        image: _courseImage!, 
        difficultyLevel: _selectedLevel!,
        price: double.parse(_priceController.text),
        hasCertificate: _hasCertificate ? "true" : "false",
      );

      if (course == null) {
        context.read<CreateCourseCubit>().createCourse(
          requestModel: requestModel,
        );
      } else if (_status == 'draft') {
        print('okk');
        context.read<CreateCourseCubit>().updateDraftCourse(
          requestModel: requestModel,
          courseId: _courseId!,
        );
      } else if (_status == 'approved') {
        context.read<CreateCourseCubit>().updateApprovedCourse(
          price: double.parse(_priceController.text),
          courseId: _courseId!,
        );
      }
      else if(_status  == 'pending' || _status == 'rejected'){
        context.read<CreateCourseCubit>().updateCourseCopy(
          requestModel: requestModel,
          courseId: _courseId!,
        );
      }
    }
  }

  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CustomColors.primary.withOpacity(0.3)),
          ),
          child: _courseImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_courseImage!, fit: BoxFit.contain),
                )
              : _existingImageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(_existingImageUrl!, fit: BoxFit.contain),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: CustomColors.primary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Add Course Image',
                      style: TextStyle(color: CustomColors.primary),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isApprovedUpdate = widget.status == 'approved';

    return BlocListener<ShowCourseCubit, ShowCourseState>(
      listener: (context, state) {
        if(state is ShowCourseSuccess)
        {
          setState(() {
            course = state.course;
            _initializeForm();
          });
        }
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text(course == null ? 'Create New Course' : 'Update Course'),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusIndicator(),
                        if(_status!='approved')
                      ElevatedButton(
  onPressed: isChanged() || context.read<IsChangedCubit>().isChanged ? () {
    if (_status == 'draft') {
      // Add your publish logic here
      context.read<CreateCourseCubit>().publishCourse( widget.courseId!,false);
    } else {
      context.read<CreateCourseCubit>().restoreCourse(courseId: widget.courseId!);
    }
  } : null, // Set to null when not dirty to disable the button
  style: ElevatedButton.styleFrom(
    backgroundColor: isChanged() || context.read<IsChangedCubit>().isChanged
        ? CustomColors.primary2 
        : Colors.grey, 
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.restore, size: 20),
      SizedBox(width: 8),
      Text(
        _status == 'draft' ? 'Publish' : 'Restore',
        style: TextStyle(fontSize: 17.r),
      ),
    ],
  ),
),
                      ],
                    ),
                    SizedBox(height: 20),
                  if (!isApprovedUpdate) ...[
                    _buildImagePicker(),
                  const SizedBox(height: 24),
                  ],
                  if (!isApprovedUpdate) ...[
                    _buildTitleField(),
                    const SizedBox(height: 20),
                  ],
                  if (!isApprovedUpdate) ...[
                    _buildDescriptionField(),
                    const SizedBox(height: 20),
                  ],
                    _buildPriceField(),
                  const SizedBox(height: 20),
                  if (!isApprovedUpdate) ...[
                    _buildLevelDropdown(),
                    const SizedBox(height: 20),
                  ],
                  if (!isApprovedUpdate) ...[
                    _buildCertificateCheckbox(),
                    const SizedBox(height: 20),
                  ],
                  if (!isApprovedUpdate) ...[
                    _buildLanguageDropdown(context),
                    const SizedBox(height: 30),
                  ],
                  if (!isApprovedUpdate) ...[
                    _buildCategoryDropdown(context),
                    const SizedBox(height: 30),
                  ],
                  if (!isApprovedUpdate) ...[
                    _buildTopicDropdown(context),
                    const SizedBox(height: 30),
                  ],
                    _buildActionButtons(),
                    SizedBox(height: 20),
                  _buildSubmitButton(widget.courseId!=null),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildStatusIndicator() {
    Color statusColor;
    
    
    switch (_status) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'draft':
        statusColor = Colors.grey;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.red;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Status: ${_status[0].toUpperCase() + _status.substring(1)}',
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if ((_status == 'approved' && numberOfStudent == 0)  || (_status == 'draft'))
          Expanded(
            child: ElevatedButton(
              onPressed: () {
              _status == 'draft' ?context.read<CreateCourseCubit>().deleteDraftCourse(courseId: widget.courseId!):context.read<CreateCourseCubit>().deleteCourse(courseId: widget.courseId!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete, size: 20),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ),
        if (_status != 'deleted')
        SizedBox(width: 12),
        
        if (_status == 'deleted')
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context.read<CreateCourseCubit>().restoreCourse(courseId: widget.courseId!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restore, size: 20),
                  SizedBox(width: 8),
                  Text('Restore'),
                ],
              ),
            ),
          ),
        if (_status == 'deleted') SizedBox(width: 12),
        
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context.pushNamed(Routes.createEpisodesScreen,arguments: {
                'isCopy':widget.isCopy,
                'status':widget.status,
                'bloc':BlocProvider.of<IsChangedCubit>(context),
                'courseId':widget.courseId,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_fill, size: 20),
                SizedBox(width: 8),
                Text('Episodes'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Course Title',
        prefixIcon: Icon(Icons.title, color: CustomColors.primary2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CustomColors.primary2.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CustomColors.primary2, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a course title';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course Description',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.primary2.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Describe your course in detail...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Course Price (\$)',
        prefixIcon: Icon(Icons.attach_money, color: CustomColors.primary2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CustomColors.primary2.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CustomColors.primary2, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a course price';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildLevelDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Course Level', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedLevel,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: CustomColors.primary2.withOpacity(0.3),
              ),
            ),
            prefixIcon: Icon(Icons.bar_chart, color: CustomColors.primary2),
          ),
          items: const [
            DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
            DropdownMenuItem(
              value: 'intermediate',
              child: Text('Intermediate'),
            ),
            DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedLevel = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a course level';
            }
            return null;
          },
          hint: const Text('Select course level'),
        ),
      ],
    );
  }

  Widget _buildCertificateCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _hasCertificate,
          activeColor: CustomColors.primary2,
          onChanged: (value) {
            setState(() {
              _hasCertificate = value!;
            });
          },
        ),
        const Text('Includes Certificate of Completion'),
      ],
    );
  }

  Widget _buildLanguageDropdown(BuildContext ctx) {
    return BlocBuilder<GetLanguageCubit, GetLanguageState>(
      builder: (context, state) {
        print(state);
        if (state is GetLanguageSuccessfully) {
          if (_selectedLanguage == null && _initialLanguage != null) {
          _selectedLanguage = context.read<GetLanguageCubit>().languageList.firstWhere(
            (lang) => lang.id == _initialLanguage,
            orElse: () => context.read<GetLanguageCubit>().languageList.first,
          );
        }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course Language',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<CountryOrLanguageSubModel>(
                initialValue: _selectedLanguage,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: CustomColors.primary2.withOpacity(0.3),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.language,
                    color: CustomColors.primary2,
                  ),
                ),
                items: context.read<GetLanguageCubit>().languageList.map((
                  language,
                ) {
                  return DropdownMenuItem(
                    value: language,
                    child: Text(language.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a language';
                  }
                  return null;
                },
                hint: const Text('Select course language'),
              ),
            ],
          );
        } else if (state is GetLanguageFailure) {
          return Text(state.errMessage);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCategoryDropdown(BuildContext ctx) {
    final categoryCubit = context.read<CategoryCubit>();

    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategorySuccess && _initialCategoryTitle != null) {
        final catego = context.read<CategoryCubit>().categoryList.firstWhere(
          (t) => t.title == _initialCategoryTitle,
          orElse: () => context.read<CategoryCubit>().categoryList.first,
        );
        context.read<CategoryCubit>().selectCategory(catego);
        context.read<TopicCubit>().getTopicsByCategory(catego.id);
        _initialCategoryTitle = null; 
      }
        print(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<CategoryModel>(
              isExpanded: true,
              initialValue: categoryCubit.selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: CustomColors.primary2.withOpacity(0.3),
                  ),
                ),
                prefixIcon: Icon(Icons.category, color: CustomColors.primary2),
              ),
              items: categoryCubit.categoryList.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.title,),
                );
              }).toList(),
              onChanged: (value) {
                categoryCubit.selectCategory(value!);
                context.read<TopicCubit>().getTopicsByCategory(
                  categoryCubit.selectedCategory!.id,
                );
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
              hint: const Text('Select course category'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopicDropdown(BuildContext ctx) {
    final topicCubit = context.read<TopicCubit>();
    return BlocBuilder<TopicCubit, TopicState>(
      builder: (context, state) {
        if (state is TopicSuccess && _initialTopicTitle != null) {
        final topic = context.read<TopicCubit>().topicList.firstWhere(
          (t) => t.title == _initialTopicTitle,
          orElse: () => context.read<TopicCubit>().topicList.first,
        );
        context.read<TopicCubit>().selectTopic(topic);
        _initialTopicTitle = null; // Reset after setting
      }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Topic',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<TopicModel>(
              initialValue: topicCubit.selectedTopic,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: CustomColors.primary2.withOpacity(0.3),
                  ),
                ),
                prefixIcon: Icon(Icons.language, color: CustomColors.primary2),
              ),
              items: topicCubit.topicList.map((topic) {
                return DropdownMenuItem(value: topic, child: Text(topic.title));
              }).toList(),
              onChanged: (value) {
                topicCubit.selectTopic(value!);
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a topic';
                }
                return null;
              },
              hint: const Text('Select course topic'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton(bool isUpdate) {
    return SizedBox(
      width: double.infinity,
      child: AppTextButton(onpressed: _submitForm, buttonText:isUpdate?'Update Course': 'Create Course'),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();   
     WidgetsBinding.instance.removeObserver(this);


    super.dispose();
  }
}
