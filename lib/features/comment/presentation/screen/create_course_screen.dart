import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_bar.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/features/courses/data/models/category_response_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';
import 'package:learning_management_system/features/courses/data/models/create_course_request_model.dart';
import 'package:learning_management_system/features/courses/data/models/topic_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_course_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_cousre_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_state.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_cubit.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_state.dart';
import 'package:learning_management_system/features/teacher/is_changed_cubit.dart';
import 'package:learning_management_system/generated/l10n.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class CreateCourseScreen extends StatefulWidget {
  String? status;
   int? courseId;
  final bool? isCopy;
  final VoidCallback? onSuccess;

  CreateCourseScreen({
    super.key,
    this.status,
    required this.courseId,
    this.isCopy,
    this.onSuccess,
  });

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  CourseDetailsModel? course;
  bool isRepost = false;

  TopicModel? _initialTopic;
  CategoryModel? _initialCategory;
  String? _existingImageUrl;
  File? newImageFile;
  String? _selectedLevel;
  bool _hasCertificate = true;
  CountryOrLanguageSubModel? _selectedLanguage;
  int? _courseId;
  int? numberOfStudent;
  String? _status;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _status = widget.status;
    if (widget.courseId != null)
      context.read<ShowCourseCubit>().showCourseForTeacher(
        widget.courseId!,
        widget.isCopy!,
      );
  }
  void _initializeForm() {
    if (course != null) {
      _courseId = course!.id;
      _titleController.text = course!.title;
      _descriptionController.text = course!.description;
      _priceController.text = course!.price.replaceFirst('\$', '');
      _selectedLevel = course!.difficultyLevel;
      _existingImageUrl = course!.imageUrl;
      numberOfStudent = course!.numOfStudentsEnrolled;
      _hasCertificate = course!.hasCertificate;
      _status = widget.status!;

      _selectedLanguage = course!.language;


      final categoryCubit = context.read<CategoryCubit>();
      categoryCubit.selectedCategory = course!.category;
      _initialCategory = course!.category!;

      final topicCubit = context.read<TopicCubit>();
      topicCubit.selectedTopic = course!.topic;
      _initialTopic = course!.topic;
    }
  }

  bool isChanged() {
    if (course != null) {
      return _titleController.text != course!.title ||
          _descriptionController.text != course!.description ||
          _priceController.text != course!.price.replaceFirst('\$', '') ||
          _selectedLevel != course!.difficultyLevel ||
          _hasCertificate != course!.hasCertificate ||
          course!.language != _selectedLanguage ||
          course!.category! != context.read<CategoryCubit>().selectedCategory ||
          course!.topic != context.read<TopicCubit>().selectedTopic ||
          _existingImageUrl != course!.imageUrl;
    }
    
    return true;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        newImageFile = File(pickedFile.path);
        _existingImageUrl = null;
      });
    }
  }

  void _submitForm() {
    print(widget.status);
    if (isChanged()) {
      if (_formKey.currentState!.validate()) {
        if (_status == 'approved') {
          context.read<CreateCourseCubit>().updateApprovedCourse(
            price: double.parse(_priceController.text),
            courseId: _courseId!,
          );
        }
        if ((newImageFile != null || _existingImageUrl != null) &&
            _selectedLevel != null &&
            _selectedLanguage != null &&
            context.read<TopicCubit>().selectedTopic != null) {
          final requestModel = CreateCourseRequestModel(
            topicId: context.read<TopicCubit>().selectedTopic!.id,
            languageId: _selectedLanguage!.id,
            title: _titleController.text,
            description: _descriptionController.text,
            image: newImageFile,
            difficultyLevel: _selectedLevel!,
            price: double.parse(_priceController.text),
            hasCertificate: _hasCertificate ? 1 : 0,
          );

          if (course == null) {
            context.read<CreateCourseCubit>().createCourse(
              requestModel: requestModel,
            );
          } else if (_status == 'draft') {
            context.read<CreateCourseCubit>().updateDraftCourse(
              requestModel: requestModel,
              courseId: _courseId!,
            );
          } else if (_status == 'pending' || _status == 'rejected') {
            context.read<CreateCourseCubit>().updateCourseCopy(
              requestModel: requestModel,
              courseId: _courseId!,
            );
          }
        } else {
          _showSnackBar(
            context,
            message: 'you should complete all field',
            contentType: ContentType.failure,
            title: 'Error',
            backgroundColor: Colors.red,
          );
        }
      }
    }
    else{
      _showSnackBar(context, message: 'No change to update', contentType: ContentType.warning, title: 'Warning !', backgroundColor: Colors.orange);
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
          child: newImageFile != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(newImageFile!, fit: BoxFit.fill),
                )
              : _existingImageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(_existingImageUrl!, fit: BoxFit.fill),
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

  
  Future<bool> _onWillPop() async {
    if (_status == "pending" ||
        _status == "rejected" && isRepost) {
      return await _showExitConfirmation() ?? false;
    } 
    return true;
  }

  void callCancelUpdating() {
    context.read<CreateCourseCubit>().cancelUpdate(widget.courseId!);
  }

  Future<bool?> _showExitConfirmation() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('ًWarrning'),
        content: Text(
          'If you make changes and do not repost , this changes will not apply',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {
            Navigator.of(context).pop(true),
            callCancelUpdating()
            },
            child: Text('Leave'),
          ),
        ],
      ),
    );
  }
  bool _isLoadingDialogShown = false;

// Replace all showDialog calls with this method
void _showLoadingDialog() {
  if (!_isLoadingDialogShown) {
    _isLoadingDialogShown = true;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Lottie.asset('assets/images/loading.json'),
    ).then((_) => _isLoadingDialogShown = false);
  }
}

// Replace all context.pop() for dismissing loading with this method
void _hideLoadingDialog() {
  if (_isLoadingDialogShown) {
    Navigator.of(context, rootNavigator: true).pop();
    _isLoadingDialogShown = false;
  }
}

  @override
  Widget build(BuildContext context) {
    print('is changed ${isChanged()} is change episode ${context.read<IsChangedCubit>().isChanged}');
    final isApprovedUpdate = widget.status == 'approved';

    

    return MultiBlocListener(
      listeners: [
        BlocListener<ShowCourseCubit, ShowCourseState>(
          listener: (context, state) {
            if (state is ShowCourseSuccess) {
              setState(() {
                course = state.course;
                _initializeForm();
              });
            } else if (state is ShowCourseLoading) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) =>
                    Lottie.asset('assets/images/loading.json'),
              );
            } else if (state is ShowCourseFailure) {
              context.pop();
              _showSnackBar(
                context,
                message: state.errMessage,
                contentType: ContentType.failure,
                title: 'Error !',
                backgroundColor: Colors.red,
              );
            }
          },
        ),
        BlocListener<CategoryCubit, CategoryState>(
          listener: (context, state) {
            if (state is CategorySuccess && _initialCategory != null ) {
              final categoryCubit = context.read<CategoryCubit>();
              context.read<TopicCubit>().getTopicsByCategory(categoryCubit.selectedCategory!.id);
            }
          },
        ),
        BlocListener<CreateCourseCubit, CreateCourseState>(
          listener: (context, state) {
            if (state is CourseSuccess) {
 _hideLoadingDialog();              _showSnackBar(
                context,
                message: state.message,
                contentType: ContentType.success,
                title: 'Success !',
                backgroundColor: Colors.green,
              );
            }
            if (state is CreateCourseSuccessfully) {
 _hideLoadingDialog();              _showSnackBar(
                context,
                message: state.course.message,
                contentType: ContentType.success,
                title: 'Success !',
                backgroundColor: Colors.green,
              );
              setState(() {
                course = state.course.course;
                _status = state.course.course.status;
                widget.courseId = state.course.course.id;
              });
            }
            if (state is UpdateStatusSuccessfully) {
 _hideLoadingDialog();              _showSnackBar(
                context,
                message: state.message,
                contentType: ContentType.success,
                title: 'Success !',
                backgroundColor: Colors.green,
              );
              if (widget.onSuccess != null) {
                widget.onSuccess!();
              }
              context.pushNamedAndRemoveUntil(
                Routes.sidebar,
                predicate: (route) => route.settings.name == Routes.sidebar,
              );
            }
            if (state is CourseLoading) {
                  _showLoadingDialog();

            }
            if (state is CourseFailure) {
              _hideLoadingDialog();     
              _showSnackBar(
                context,
                message: state.errMessage,
                contentType: ContentType.failure,
                title: 'Error !',
                backgroundColor: Colors.red,
              );
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: CustomAppBar(
            showBackButton: false,
            title:course == null ? 'Create New Course' : 'Update Course',
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
                      if (_status != null) _buildStatusIndicator(),
                      if (_status != 'approved' && _status!= null)
                        ElevatedButton(
                          onPressed: () {
                            if (_status == 'draft') {
                              context.read<CreateCourseCubit>().publishCourse(
                                widget.courseId!,
                                false,
                              );
                            } else {
                              context.read<CreateCourseCubit>().publishCourse(
                                widget.courseId!,
                                true,
                              );
                              setState(() {
                                isRepost = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                CustomColors.primary2,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _status == 'draft'? Icon(Icons.publish, size: 20):Icon(Icons.restore, size: 20),
                              SizedBox(width: 8),
                              Text(
                                _status == 'draft'  ? 'Publish' : 'Repost',
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
                  if(_status == 'approved')
                  SizedBox(height: 340),
                  if (_status != null)
                  _buildActionButtons(),
                  SizedBox(height: 10.h,),
                  _buildSubmitButton(course != null),
                  SizedBox(height: 20.h,)
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
            'Status: ${_status![0].toUpperCase() + _status!.substring(1)}',
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if ((_status == 'approved' && numberOfStudent == 0) ||
            (_status == 'draft'))
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _status == 'draft'
                    ? context.read<CreateCourseCubit>().deleteDraftCourse(
                        courseId: widget.courseId!,
                      )
                    : context.read<CreateCourseCubit>().deleteCourse(
                        courseId: widget.courseId!,
                      );
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
        SizedBox(width: 12),

        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context.pushNamed(
                Routes.createEpisodesScreen,
                arguments: {
                  'isCopy': widget.isCopy,
                  'status': widget.status,
                  'bloc': BlocProvider.of<IsChangedCubit>(context),
                  'courseId': widget.courseId,
                },
              );
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
        prefixIcon: Icon(Icons.attach_money, color: Color(0xff25bd25)),
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
          value: _selectedLevel,
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
            DropdownMenuItem(value: 'expert', child: Text('Expert')),
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course Language',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<CountryOrLanguageSubModel>(
                value: _selectedLanguage,
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
              value: categoryCubit.selectedCategory,
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
                  child: Text(category.title),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                categoryCubit.selectCategory(value);
                context.read<TopicCubit>().resetTopic();
                context.read<TopicCubit>().getTopicsByCategory(value.id);
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
    return BlocBuilder<TopicCubit, TopicState>(
      builder: (context, state) {
        final topicCubit = context.read<TopicCubit>();
        if (state is TopicLoading) {
          return Center(
            child: CircularProgressIndicator(color: CustomColors.primary2),
          );
        }
        if (state is TopicFailure) {
          return Center(child: Text(state.errMessage));
        }
        if(state is TopicSuccess || state is ChangeTopic)
        return _buildTopicDropdownContent(topicCubit);

        return SizedBox();
      },
    
    );
  }

  Widget _buildTopicDropdownContent(TopicCubit topicCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Course Topic', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<TopicModel>(
          value: topicCubit.selectedTopic,
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
            if (value == null) 
            return;
            topicCubit.selectTopic(value);
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
  }

  Widget _buildSubmitButton(bool isUpdate) {
    return SizedBox(
      width: double.infinity,
      child: AppTextButton(
        onpressed: _submitForm,
        buttonText: isUpdate ? 'Update Course' : 'Create Course',
      ),
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

void _showSnackBar(
  BuildContext context, {
  required String message,
  required ContentType contentType,
  required String title,
  required Color backgroundColor,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      color: backgroundColor,
      title: title,
      message: message,

      contentType: contentType,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}