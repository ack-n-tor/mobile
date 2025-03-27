import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/upload_file/bloc/bloc.dart';

class UploadContent extends StatelessWidget {

  final Function(FileUpload? data) onFileUploaded;
  final String? initialAvatar;

  const UploadContent({super.key,required this.onFileUploaded,this.initialAvatar});

  @override
  Widget build(BuildContext context) {

    return BlocProvider<UploadFileBloc>(
      create: (context) => UploadFileBloc(metaClubApiClient: MetaClubApiClient(httpService: instance())),
      child: BlocListener<UploadFileBloc,UploadFileState>(
        listener: (context,state){
          if(state.networkStatus == NetworkStatus.success){
            onFileUploaded(state.fileUpload);
          }
        },
        child: BlocBuilder<UploadFileBloc,UploadFileState>(builder: (context, state) {
          return InkWell(
            onTap: () {
              context.read<UploadFileBloc>().add(SelectFile(context: context));
            },
            child: ClipOval(
              child: state.networkStatus != NetworkStatus.loading ? CachedNetworkImage(
                height: 120,
                width: 120,
                fit: BoxFit.cover,
                imageUrl: '${state.fileUpload?.previewUrl ?? initialAvatar}',
                placeholder: (context, url) => Center(
                  child: Image.asset("assets/images/app_icon.png"),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ) : const CircularProgressIndicator(),
            ),
          );
        }),
      ),
    );
  }
}
