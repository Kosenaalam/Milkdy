import 'package:supabase_flutter/supabase_flutter.dart';

  Future<void> initSupabase() async {

    await Supabase.initialize(
      url: 'https://xmogfoxbdkzprrtojflw.supabase.co',
      anonKey: 'sb_publishable_Htf38N67vsZt_lmeTglSgQ_R9dUC9ri',
    );
  }
 SupabaseClient get supabase => Supabase.instance.client;