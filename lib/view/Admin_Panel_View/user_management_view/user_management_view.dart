/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/app_colors.dart';
import 'package:rise_college/utils/routes/routes_name.dart';
import 'package:rise_college/utils/utils.dart';
import '../../../viewModel/AdminViewModel/user_management_view_model/user_management_view_model.dart';

class UserManagementViewByAdmin extends StatelessWidget {
  const UserManagementViewByAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body: Consumer<UserManagementViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Header + Add button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'User Management',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add User'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pushNamed(context, RoutesName.createUserByAdminView),
                    ),
                  ],
                ),
              ),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip(viewModel, 'All'),
                    const SizedBox(width: 8),
                    _buildFilterChip(viewModel, 'Teacher'),
                    const SizedBox(width: 8),
                    _buildFilterChip(viewModel, 'Student'),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Main list
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: viewModel.allUsersStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      if (kDebugMode) {
                        print("Error is: ${snapshot.error}");
                      }
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    final allUsers = snapshot.data ?? [];
                    final filteredUsers = viewModel.selectedRole == 'All' ? allUsers : allUsers.where((u) => u['role'] == viewModel.selectedRole).toList();

                    if (filteredUsers.isEmpty) {
                      return const Center(child: Text("No Users found"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 3,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: user['role'] == 'Teacher' ? Colors.green[700] : Colors.blue[700],
                              child: Icon(
                                user['role'] == 'Teacher' ?  Icons.school:Icons.person, color: Colors.white,
                              ),
                            ),
                            title: Text(
                              user['displayName'] ?? 'No Name',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user['email'] ?? '—'),
                                Text("${user['role']} • ${user['faculty'] ?? '—'}"),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if(value =='edit'){
                                  Navigator.pushNamed(context, RoutesName.editUserByAdminView, arguments: user);

                                  // _showEditUserDialog(context, viewModel,user);
                                }
                                else if (value == 'delete') {
                                  _confirmDelete(context, viewModel, user['uid']);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                ),

                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete',
                                      style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(UserManagementViewModel vm, String role) {
    return ChoiceChip(
      label: Text(role),
      selected: vm.selectedRole == role,
      onSelected: (selected) {
        if (selected) {
          vm.filterByRole(role);
        }
      },
      // selectedColor: const Color(0xFF6A1B9A),
      selectedColor: AppColors.mediumMaroon,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: vm.selectedRole == role ? Colors.white : Colors.black87,
      ),
      showCheckmark: false,
    );
  }

  // Confirm Delete User Dialog Field
  void _confirmDelete(BuildContext context, UserManagementViewModel viewModel, String? uid) {
    if (uid == null || uid.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
         viewModel.loading? CircularProgressIndicator() : ElevatedButton(

            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await viewModel.deleteUserByAdmin(uid);
              if(ctx.mounted){
                Navigator.pop(ctx);
                Utils.toastMessage("User has Been Deleted", AppColors.warning, AppColors.black);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/app_colors.dart';
import 'package:rise_college/utils/routes/routes_name.dart';
import 'package:rise_college/utils/utils.dart';
import '../../../viewModel/AdminViewModel/user_management_view_model/user_management_view_model.dart';

class UserManagementViewByAdmin extends StatelessWidget {
  const UserManagementViewByAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body: Consumer<UserManagementViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Header + Add button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'User Management',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add User'),
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: const Color(0xFF6A1B9A),
                        backgroundColor: AppColors.lightMaroon,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pushNamed(
                          context, RoutesName.createUserByAdminView),
                    ),
                  ],
                ),
              ),

              // Role filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildRoleChip(viewModel, 'All'),
                    const SizedBox(width: 8),
                    _buildRoleChip(viewModel, 'Teacher'),
                    const SizedBox(width: 8),
                    _buildRoleChip(viewModel, 'Student'),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Status filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatusChip(viewModel, 'all', 'All'),
                    const SizedBox(width: 8),
                    _buildStatusChip(viewModel, 'pending', 'Pending'),
                    const SizedBox(width: 8),
                    _buildStatusChip(viewModel, 'active', 'Active'),
                    const SizedBox(width: 8),
                    _buildStatusChip(viewModel, 'rejected', 'Rejected'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // User list
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: viewModel.allUsersStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      if (kDebugMode) print("Error: ${snapshot.error}");
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    final allUsers = snapshot.data ?? [];

                    var filtered = viewModel.selectedRole == 'All'
                        ? allUsers
                        : allUsers.where((u) => u['role'] == viewModel.selectedRole).toList();

                    if (viewModel.selectedStatus != 'all') {
                      filtered = filtered.where((u) =>
                      (u['status']?.toString().toLowerCase() ?? '') ==
                          viewModel.selectedStatus).toList();
                    }

                    if (filtered.isEmpty) {
                      return const Center(child: Text("No users found"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return _buildUserCard(context, viewModel, filtered[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // User card
  Widget _buildUserCard(BuildContext context, UserManagementViewModel viewModel,
      Map<String, dynamic> user) {
    final status = user['status']?.toString().toLowerCase() ?? 'active';
    final role = user['role']?.toString() ?? '';
    final isPending = status == 'pending';
    final isRejected = status == 'rejected';
    final rollNo = user['rollNo']?.toString() ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isPending
            ? const BorderSide(color: Colors.orange, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: avatar + info + popup
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: role == 'Teacher' ? Colors.green[700] : Colors.blue[700],
                  child: Icon(
                    role == 'Teacher' ? Icons.school : Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['displayName'] ?? 'No Name',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(user['email'] ?? '--',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      Text(
                        "${user['role']} • ${user['faculty'] ?? '--'}"
                            "${rollNo.isNotEmpty ? ' • Roll: $rollNo' : ''}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(status),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.pushNamed(context, RoutesName.editUserByAdminView,
                          arguments: user);
                    } else if (value == 'delete') {
                      _confirmDelete(context, viewModel, user['uid']);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),

            // Approve / Reject row for pending students
            if (isPending && role == 'Student') ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text('Awaiting approval',
                      style: TextStyle(fontSize: 12, color: Colors.orange[700])),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _confirmReject(context, viewModel, user['uid']),
                    icon: const Icon(Icons.close, size: 14, color: Colors.red),
                    label: const Text('Reject',
                        style: TextStyle(color: Colors.red, fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _showApproveDialog(context, viewModel, user['uid']),
                    icon: const Icon(Icons.check, size: 14),
                    label: const Text('Approve', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
            ],

            // Re-activate button for rejected students
            if (isRejected && role == 'Student') ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () =>
                        _showApproveDialog(context, viewModel, user['uid']),
                    icon: const Icon(Icons.refresh, size: 14),
                    label: const Text('Re-activate', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Approve dialog - Admin must enter Roll Number before approving
  void _showApproveDialog(BuildContext context, UserManagementViewModel vm,
      String? uid) {
    if (uid == null || uid.isEmpty) return;

    final rollController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.how_to_reg, color: Colors.green),
            SizedBox(width: 8),
            Text('Approve Student'),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assign a Roll Number to this student before approving.',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: rollController,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'Roll Number',
                  hintText: 'e.g. CS-2024-001',
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a roll number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Approve'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await vm.approveUser(uid, rollController.text.trim());
              if (ctx.mounted) Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  void _confirmReject(BuildContext context, UserManagementViewModel vm,
      String? uid) {
    if (uid == null || uid.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Student'),
        content: const Text(
            'Are you sure? This student will be blocked from accessing the app.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await vm.rejectUser(uid);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, UserManagementViewModel vm,
      String? uid) {
    if (uid == null || uid.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          vm.loading
              ? const CircularProgressIndicator()
              : ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await vm.deleteUserByAdmin(uid);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                Utils.toastMessage(
                    "User Deleted", AppColors.warning, AppColors.black);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Rejected';
        break;
      default:
        color = Colors.green;
        label = 'Active';
    }
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildRoleChip(UserManagementViewModel vm, String role) {
    return ChoiceChip(
      label: Text(role),
      selected: vm.selectedRole == role,
      onSelected: (selected) { if (selected) vm.filterByRole(role); },
      selectedColor: AppColors.mediumMaroon,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
          color: vm.selectedRole == role ? Colors.white : Colors.black87),
      showCheckmark: false,
    );
  }

  Widget _buildStatusChip(UserManagementViewModel vm, String status, String label) {
    Color activeColor;
    switch (status) {
      case 'pending': activeColor = Colors.orange; break;
      case 'rejected': activeColor = Colors.red; break;
      case 'active': activeColor = Colors.green; break;
      default: activeColor = AppColors.mediumMaroon;
    }
    return ChoiceChip(
      label: Text(label),
      selected: vm.selectedStatus == status,
      onSelected: (selected) { if (selected) vm.filterByStatus(status); },
      selectedColor: activeColor,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
          color: vm.selectedStatus == status ? Colors.white : Colors.black87),
      showCheckmark: false,
    );
  }
}