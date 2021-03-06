# Copyright 2018 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""This file contains rules used to bootstrap the compiler repository."""

load("//kotlin/internal:kt.bzl", "kt")
load("//kotlin/internal:rules.bzl", _kt_jvm_import_impl="kt_jvm_import_impl")

kotlin_stdlib = rule(
    attrs = {
        "jars": attr.label_list(
            allow_files = True,
            mandatory = True,
            cfg = "host",
        ),
        "srcjar": attr.label(
            allow_single_file = True,
            cfg = "host",
        ),
    },
    implementation = _kt_jvm_import_impl,
)

"""Import Kotlin libraries that are part of the compiler release."""

def github_archive(name, repo, commit, build_file_content = None):
    if build_file_content:
        native.new_http_archive(
            name = name,
            strip_prefix = "%s-%s" % (repo.split("/")[1], commit),
            url = "https://github.com/%s/archive/%s.zip" % (repo, commit),
            type = "zip",
            build_file_content = build_file_content,
        )
    else:
        native.http_archive(
            name = name,
            strip_prefix = "%s-%s" % (repo.split("/")[1], commit),
            url = "https://github.com/%s/archive/%s.zip" % (repo, commit),
            type = "zip",
        )
